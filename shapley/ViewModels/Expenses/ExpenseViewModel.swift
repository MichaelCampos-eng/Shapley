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
    @Published var user: UserBill? = nil
    @Published var model: Model? = nil
    
    private var userModelReg: ListenerRegistration?
    private var modelReg: ListenerRegistration?
    
    private var meta: MetaExpense
    
    init(meta: MetaExpense) {
        self.meta = meta
        self.beginListening()
    }
    
    private func beginListening() {
        fetchUserModel()
        fetchModel()
    }
    
    private func endListening() {
        userModelReg?.remove()
        modelReg?.remove()
        userModelReg = nil
        modelReg = nil
    }
    
    private func fetchUserModel() {
        let db = Firestore.firestore()
        userModelReg = db.collection("users/\(self.getUserId())/activities/\(self.getActivityId())/models").document(self.getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let userModel = try? snapshot?.data(as: UserBill.self) else {
                self?.create()
                return
            }
            self?.user = userModel
        }
    }
    
    
    private func create() {
        let db = Firestore.firestore()
        do {
            try db.collection("users")
                .document(getUserId())
                .collection("activities")
                .document(getActivityId())
                .collection("models")
                .document(getModelId())
                .setData(from: UserBill(owner: false,
                                  claims: [:],
                                  createdDate: Date().timeIntervalSince1970))
        } catch {
            print(error)
        }
    }
    
    private func fetchModel() {
        let db = Firestore.firestore()
        modelReg = db.collection("activities/\(self.getActivityId())/models").document(self.getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let model = try? snapshot?.data(as: Model.self) else {
                print("Model does not exist or was not able to be decoded. - ExpenseViewModel")
                return
            }
            self?.model = model
        }
    }
    
    func updateTitle(name: String) {
        let db = Firestore.firestore()
        let ref = db.collection("activities/\(self.getActivityId())/models").document(self.getModelId())
        ref.updateData(["title" : name]) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
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
    
    func isAvailable() -> Bool {
        if user != nil && model != nil {
            return true
        }
        return false
    }

    func getType() -> ExpenseType {
        return meta.type
    }
    
    private func getUserId() -> String {
        return meta.paths.userId!
    }
    
    private func getActivityId() -> String {
        return meta.paths.activityId!
    }
    
    private func getModelId() -> String {
        return meta.paths.modelId!
    }
}
