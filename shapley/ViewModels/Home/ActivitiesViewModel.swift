//
//  ActivitiesViewModel.swift
//  shapley
//
//  Created by Michael Campos on 5/28/24.

import FirebaseFirestore
import Foundation
import Combine

class ActivitiesViewModel: ObservableObject {
    @Published var showingNewActivity = false
    
    @Published var userData: [UserActivity] = []
    @Published var contents: [ContentActivity] = []
    @Published var metadata: [MetaActivity] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
        fetchUserData()
        fetchContents()
        fetchMetadata()
    }
    
    private func fetchUserData() {
        let db = Firestore.firestore()
        db.collection("users/\(self.userId)/activities").addSnapshotListener { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            self?.userData = documents.compactMap{queryDocumentSnapshot -> UserActivity? in
                return try? queryDocumentSnapshot.data(as: UserActivity.self)
            }
        }
    }
    
    private func fetchContents() {
        let db = Firestore.firestore()
        db.collection("activities").addSnapshotListener{[weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
            self?.contents = documents.compactMap { queryDocumentSnapshot -> ContentActivity? in
                return try? queryDocumentSnapshot.data(as: ContentActivity.self)
            }
        }
    }
    
    private func fetchMetadata() {
        Publishers.CombineLatest($userData, $contents)
            .map { userData, contents in
                return userData.flatMap{ activityUser in
                    contents.compactMap { activityContent in
                        activityUser.id == activityContent.id ? MetaActivity(userId: self.userId,
                                                                             id: activityContent.id,
                                                                             title: activityContent.title,
                                                                             createdDate: activityContent.createdDate) : nil
                    }
                }
            }
            .assign(to: \.metadata, on: self)
            .store(in: &cancellables)
    }
    
    // TODO: Make sure the right user deletes the activity from contents
    /// Delete activity
    /// - Parameter id: activity id to delete
    func delete(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("activities")
            .document(id)
            .delete()
    }
    
}
