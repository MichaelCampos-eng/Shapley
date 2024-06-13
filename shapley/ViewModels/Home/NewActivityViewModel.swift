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
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let activityId = UUID().uuidString
        let groupId = self.generateAlphanumericID(length: 8)
        
        let userActivity = UserActivity(isAdmin: true, id: activityId)
        let content = ContentActivity(id: activityId,
                                      createdDate: Date().timeIntervalSince1970,
                                      title: self.activityName,
                                      groupId: groupId)
        
        // Save user metadata for a particular activity
        self.saveUserActivity(userId: userId, userActivity: userActivity)
        
        // Save content metadata about activity
        self.saveContentActivity(content: content)
    }
    
    
    private func saveUserActivity(userId: String, userActivity: UserActivity) -> Void {
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("activities")
            .document(userActivity.id)
            .setData(userActivity.asDictionary(), completion: {error in
                if let error = error {
                    print("Error saving user activity: \(error.localizedDescription)")
                } else {
                    print("Sucessfully saved user activity!")
                }
            })
    }
    
    private func saveContentActivity(content: ContentActivity) -> Void {
        let db = Firestore.firestore()
        db.collection("activities")
            .document(content.id)
            .setData(content.asDictionary(), completion: {error in
                if let error = error {
                    print("Error saving content activty: \(error.localizedDescription)")
                } else {
                    print("Successfully saved content activity!")
                }
            })
    }
    
    private func generateAlphanumericID(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var result = ""
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let randomCharacter = characters.index(characters.startIndex, offsetBy: randomIndex)
            result.append(characters[randomCharacter])
        }
        return result
    }
    
    
    // TODO: complete join feature
    public func join() -> Void {
        
        let db = Firestore.firestore()
        let activities = db.collection("activities")

        activities.whereField("groupId", isEqualTo: groupId).getDocuments{ [weak self] snapshot, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else if let snapshot = snapshot {
                
                if snapshot.documents.isEmpty {
                    self?.alertMessage = "Invalid Group Id"
                }
                
                for document in snapshot.documents {
                    do {
                        guard let userId = Auth.auth().currentUser?.uid else {
                            return
                        }
                        
                        let activityId = try document.data(as: ContentActivity.self).id
                        let userActivity = UserActivity(isAdmin: false, id: activityId)
                        self?.saveUserActivity(userId: userId, userActivity: userActivity)
                        
                    } catch {
                        print("Error decoding document: \(error.localizedDescription)")
                    }
                }
            }
        }
        
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
