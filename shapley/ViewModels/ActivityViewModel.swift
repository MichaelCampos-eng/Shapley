//
//  ActivityViewModel.swift
//  shapley
//
//  Created by Michael Campos on 5/28/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class ActivityViewModel: ObservableObject {
    init() {
    }
    
    
    func toggleIsDone(activity: Activity) {
        var activityCopy = activity
        activityCopy.setDone(!activityCopy.isDone)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(activityCopy.id)
            .setData(activityCopy.asDictionary())
        
    }
}
