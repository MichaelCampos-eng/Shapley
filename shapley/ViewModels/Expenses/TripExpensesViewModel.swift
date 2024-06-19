//
//  TripExpensesModel.swift
//  shapley
//
//  Created by Michael Campos on 6/2/24.
//

import FirebaseFirestore
import Foundation
import Combine 

class TripExpensesViewModel: ObservableObject {
    @Published var showingNewTrip: Bool = false
    @Published var showingManageGroup: Bool = false
    
    @Published var userTrips: [UserTrip] = []
    @Published var contentTrips: [ContentTrip] = []
    @Published var trips: [MetaTrip] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let activityId: String
    private let userId: String
    
    private var userData: UserActivity? = nil
    
    init(userId: String, activityId: String) {
        self.activityId = activityId
        self.userId = userId
        self.fetchUserTrip()
        self.fetchContentTrip()
        self.fetchTrip()
    }
    
    private func fetchUserData() {
        let db = Firestore.firestore()
        let document = db.collection("users/\(self.userId)/activities").document(self.activityId)
        
        document.getDocument(as: UserActivity.self) { [weak self] result in
            switch result {
            case .success(let userActivity):
                self?.userData = userActivity
                
            case .failure(let error):
                print("Error fetchng document \(error.localizedDescription)")
            }
        }
    }
    
    public func isAdmin() -> Bool {
        return userData!.isAdmin
    }
    
    public func getActivityId() -> String {
        return self.activityId
    }
        
    
    private func fetchUserTrip() {
        let db = Firestore.firestore()
        db.collection("users/\(self.userId)/activities/\(self.activityId)/trips").addSnapshotListener { [weak self] snapshot, error in
            
            guard let documents = snapshot?.documents else {
                print("No trips")
                return
            }
            
            self?.userTrips = documents.compactMap{queryDocumentSnapshot -> UserTrip? in
                return try? queryDocumentSnapshot.data(as: UserTrip.self)
            }
        }
    }
    
    private func fetchContentTrip() {
        let db = Firestore.firestore()
        
        db.collection("activities/\(self.activityId)/trips").addSnapshotListener { [weak self] snapshot, error in
            
            guard let documents = snapshot?.documents else {
                print("No trips")
                return
            }
            
            self?.contentTrips = documents.compactMap{ queryDocumentSnapshot -> ContentTrip? in
                return try? queryDocumentSnapshot.data(as: ContentTrip.self)
            }
        }
    }
    
    private func fetchTrip() {
        Publishers.CombineLatest($userTrips, $contentTrips)
            .map { [weak self] user, contents in
                return self?.generateMetaTrips(user: user, contents: contents) ?? []
            }
            .assign(to: \.trips, on: self)
            .store(in: &cancellables)
        
    }
    
    private func generateMetaTrips(user: [UserTrip], contents: [ContentTrip]) -> [MetaTrip] {
        let meta = user.flatMap{ userTrip in
            contents.compactMap { contentTrip in
                userTrip.id == contentTrip.id ? MetaTrip(id: contentTrip.id) : nil
            }
        }
        return meta
    }
    
}
