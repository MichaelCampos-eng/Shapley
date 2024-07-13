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
    private var bill: [UserBill] = []
    private var model: [Model] = []
    private var meta: MetaTrip
    
    init(meta: MetaTrip) {
        self.meta = meta
    }
    
    public func validate(bill: [UserBill], model: [Model]) -> Bool{
        guard bill.count == 1, model.count == 1 else {
            return false
        }
        self.bill = bill
        self.model = model
        return true
    }
    
    public func getMeta() -> MetaTrip {
        return meta
    }
    
    public func isOwner() -> Bool {
        return bill.first!.owner
    }
    
    public func getType() -> ExpenseType {
        return model.first!.type
    }
    
    public func getTitle() -> String {
        return model.first!.title
    }
    
    public func getCreatedDate() -> TimeInterval {
        return model.first!.createdDate
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
    
    public func delete() {
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
