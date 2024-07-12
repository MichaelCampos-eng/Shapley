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
    
    @Published var userTrips: [UserBill] = []
    @Published var models: [Model] = []
    @Published var trips: [MetaTrip] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let activityId: String
    private let userId: String
    
    private var userData: UserActivity? = nil
    
    init(userId: String, activityId: String) {
        self.activityId = activityId
        self.userId = userId
        self.fetchUserBills()
        self.fetchModels()
        self.fetchExpense()
    }
    
    private func fetchUserData() {
        let db = Firestore.firestore()
        let document = db.collection("users/\(self.userId)/activities").document(self.activityId)
        
        document.getDocument(as: UserActivity.self) { [weak self] result in
            switch result {
            case .success(let userActivity):
                self?.userData = userActivity
                
            case .failure(let error):
                print("Error fetching document \(error.localizedDescription)")
            }
        }
    }
    
    public func isAdmin() -> Bool {
        return userData!.isAdmin
    }
    
    public func getActivityId() -> String {
        return self.activityId
    }
        
    
    private func fetchUserBills() {
        let db = Firestore.firestore()
        db.collection("users/\(self.userId)/activities/\(self.activityId)/models").addSnapshotListener { [weak self] snapshot, error in
            
            guard let documents = snapshot?.documents else {
                print("No trips")
                return
            }
            
            self?.userTrips = documents.compactMap{queryDocumentSnapshot -> UserBill? in
                return try? queryDocumentSnapshot.data(as: UserBill.self)
            }
        }
    }
    
    private func fetchModels() {
        let db = Firestore.firestore()
        
        db.collection("activities/\(self.activityId)/models").addSnapshotListener { [weak self] snapshot, error in
            
            guard let documents = snapshot?.documents else {
                print("No trips")
                return
            }
            
            self?.models = documents.compactMap{ queryDocumentSnapshot -> Model? in
                return try? queryDocumentSnapshot.data(as: Model.self)
            }
        }
    }
    
    private func fetchExpense() {
        Publishers.CombineLatest($userTrips, $models)
            .map { [weak self] user, contents in
                return self?.generateMetaTrips(user: user, contents: contents) ?? []
            }
            .assign(to: \.trips, on: self)
            .store(in: &cancellables)
        
    }
    
    private func generateMetaTrips(user: [UserBill], contents: [Model]) -> [MetaTrip] {
        let meta = user.flatMap{ bill in
            contents.compactMap { model in
                bill.id == model.id ? MetaTrip(id: model.id,
                                               userId: self.userId,
                                               activityId: self.activityId) : nil
            }
        }
        return meta
    }
    
}
