//
//  TripViewModel.swift
//  shapley
//
//  Created by Michael Campos on 7/11/24.
//

import Foundation
import FirebaseFirestore

class ExpenseViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var bill: UserBill? = nil
    @Published var model: Model? = nil
    private var meta: MetaTrip
    
    init(meta: MetaTrip) {
        self.meta = meta
        self.fetchModel()
        self.fetchUserModel()
    }
    
    private func fetchUserModel() {
        let db = Firestore.firestore()
        db.collection("users/\(self.getUserId())/activities/\(self.getActivityId())/models").document(self.getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let userModel = try? snapshot?.data(as: UserBill.self) else {
                print("Document does not exist or was not able to be decoded.")
                return
            }
            self?.bill = userModel
        }
    }
    
    private func fetchModel() {
        let db = Firestore.firestore()
        db.collection("activities/\(self.getActivityId())/models").document(self.getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let model = try? snapshot?.data(as: Model.self) else {
                print("Document does not exist or was not able to be decoded")
                return
            }
            self?.model = model
        }
    }
    
    func valid() -> Bool {
        if bill != nil && model != nil {
            return true
        }
        return false
    }
    
    func getMeta() -> MetaTrip {
        return meta
    }
    
    func isOwner() -> Bool {
        return bill!.owner
    }
    
    func getType() -> ExpenseType {
        return model!.type
    }
    
    func getTitle() -> String {
        return model!.title
    }
    
    func getCreatedDate() -> TimeInterval {
        return model!.createdDate
    }
    
    private func getUserId() -> String {
        return self.meta.userId
    }
    
    private func getActivityId() -> String {
        return self.meta.activityId
    }
    
    private func getModelId() -> String {
        return self.meta.id
    }
    
    func delete() {
        self.errorMessage = ""
        let db = Firestore.firestore()
        db.collection("users")
            .document(self.getUserId())
            .collection("activities")
            .document(self.getActivityId())
            .collection("models")
            .document(self.getModelId())
            .delete()
        
        db.collection("activities")
            .document(self.getActivityId())
            .collection("models")
            .document(self.getModelId())
            .delete()
    }
}
