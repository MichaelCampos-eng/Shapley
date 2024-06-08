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
        let groupId = UUID().uuidString
        
        
        let activityUser = UserActivity(admin: true, id: newId, groupId: groupId)
        let activityContent = ContentActivity(id: newId, title: activityName, createdDate: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        // Save user metadata for a particular activity
        db.collection("users")
            .document(uId)
            .collection("activities")
            .document(newId)
            .setData(activityUser.asDictionary())
        
        // Save content metadata about activity
        db.collection("content")
            .document(newId)
            .setData(activityContent.asDictionary())
        
    }
    
    // TODO: complete join feature
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
