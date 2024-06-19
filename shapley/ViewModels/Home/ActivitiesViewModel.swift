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
    public var errorMessage: String = ""
    
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
        db.collection("activities").addSnapshotListener{ [weak self] snapshot, error in
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
            .map { [weak self] userData, contents in
                return self?.generateMetaActivities(userData: userData, contents: contents) ?? []
            }
            .assign(to: \.metadata, on: self)
            .store(in: &cancellables)
    }
    
    
    private func generateMetaActivities(userData: [UserActivity], contents: [ContentActivity]) -> [MetaActivity] {
            let metaActivities = userData.flatMap { userActivity in
                contents.compactMap { contentActivity in
                    return userActivity.id == contentActivity.id ? MetaActivity(userId: self.userId,
                                                                         id: contentActivity.id,
                                                                         createdDate: contentActivity.createdDate) : nil
                }
            }
            return metaActivities.sorted { $0.createdDate > $1.createdDate }
        }
}
