//
//  NewActivityViewModel.swift
//  shapley
//
//  Created by Michael Campos on 5/28/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class NewActivityViewModel: ObservableObject {
    @Published var groupId = ""
    @Published var activityName = ""
    @Published var showAlert = false
    var alertMessage = ""
    
    init() {
        
    }
    
    public func create() -> Void {
        
        guard canCreate else {
            return
        }
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        
        let newId = UUID().uuidString
        let activity = Activity(id: newId,
                                title: activityName,
                                createdDate: Date().timeIntervalSince1970,
                                isDone: false)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("todos")
            .document(newId)
            .setData(activity.asDictionary())
        
    }
    
    public func join() -> Void {
        
    }
    
    var canCreate: Bool {
        guard !activityName.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Fill out activity name."
            return false
        }
        return true
    }
    
    var canJoin: Bool {
        guard !groupId.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Invalid Group Id."
            return false
        }
        return true
    }
    
    
    
}
