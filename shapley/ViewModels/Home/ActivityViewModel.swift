//
//  ActivityViewModel.swift
//  shapley
//
//  Created by Michael Campos on 6/10/24.
//

import FirebaseFirestore
import Foundation

class ActivityViewModel: ObservableObject {
    @Published var errorMessage = ""
    private var user: [UserActivity] = []
    private var content: [ContentActivity] = []
    private var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func getUserId() -> String {
        return self.userId
    }
    
    func getContentId() -> String {
        return self.content.first!.id
    }
    
    func isAdmin() -> Bool {
        return user.first!.isAdmin
    }
    
    func getTitle() -> String {
        return content.first!.title
    }
    
    func getCreatedDate() -> TimeInterval {
        return content.first!.createdDate
    }
 
    func validate(user: [UserActivity], content: [ContentActivity]) -> Bool {
        guard user.count == 1, content.count == 1 else {
            return false
        }
        // Update user and content attribtutes
        self.user = user
        self.content = content 
        return true
    }
    
    func updateTitle(name: String) {
        let db = Firestore.firestore()
        let document = db.collection("activities").document(content.first!.id)
     
        document.getDocument(as: ContentActivity.self) { result in
            switch result {
            case .success(let contentActivity):
                var updated = contentActivity
                updated.changeTitle(name)
                document.setData(updated.asDictionary()) { error in
                    if let error  = error {
                        print("Error saving document: \(error.localizedDescription)")
                    } else {
                        print("Document sucessfully updated!")
                    }
                }
            case .failure(let error):
                print ("Error encoding: \(error.localizedDescription)")
            }
            
        }
    }
    
    
    // TODO: Make sure the right user deletes the activity from contents
    /// Delete activity
    /// - Parameter id: activity id to delete
    func delete() {
        self.errorMessage = ""
        let db = Firestore.firestore()
        let document = db.collection("users")
            .document(self.userId)
            .collection("activities")
            .document(content.first!.id)
        document.delete()
        
        if self.isAdmin() {
            db.collection("activities")
                .document(content.first!.id)
                .delete()
        }
    }
}
    

