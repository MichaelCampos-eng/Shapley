//
//  ActivitiesViewModel.swift
//  shapley
//
//  Created by Michael Campos on 5/28/24.
//

import FirebaseFirestore
import Foundation

class ActivitiesViewModel: ObservableObject {
    @Published var showingNewActivity = false
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    /// Delete activity
    /// - Parameter id: activity id to deletet
    func delete(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(id)
            .delete()
    }
    
}
