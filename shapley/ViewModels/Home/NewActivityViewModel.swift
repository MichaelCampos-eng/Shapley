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
    
    private var user: User?
    var alertMessage = ""
    
    init() {
        self.fetchUser()
    }
    
    func create() -> Void {
        guard canCreate else {
            return
        }
        guard let currentUser = self.user else {
            return
        }
        let activityId = UUID().uuidString
        let groupId = self.generateAlphanumericID(length: 8)
        let userActivity = UserActivity(id: activityId, isAdmin: true, tempName: currentUser.name)
        let content = ContentActivity(id: activityId,
                                      createdDate: Date().timeIntervalSince1970,
                                      title: self.activityName,
                                      groupId: groupId,
                                      validUsers: [currentUser.id])
        self.saveUserActivity(userId: currentUser.id, userActivity: userActivity)
        self.saveContentActivity(content: content)
    }
    
    private func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).addSnapshotListener{ [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                print("User does not exist.")
                return
            }
            self?.user = try? snapshot.data(as: User.self)
        }
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
                    print("Successfully saved user activity!")
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

    func join() async {
        let db = Firestore.firestore()
        do {
            let snapshot = try await db.collection("activities").whereField("groupId", isEqualTo: groupId).getDocuments()
            for document in snapshot.documents {
                do {
                    guard let currentUser = self.user else { return }
                    var activity = try document.data(as: ContentActivity.self)
                    let validUsers = activity.validUsers
                    if !validUsers.contains(currentUser.id) {
                        activity.addUser(currentUser.id)
                        try await document.reference.setData(activity.asDictionary())
                    }
                    let activityId = activity.id
                    let userActivity = UserActivity(id: activityId, isAdmin: false, tempName: currentUser.name)
                    self.saveUserActivity(userId: currentUser.id, userActivity: userActivity)
                } catch {
                    print("Error decoding document: \(error.localizedDescription)")
                }
            }
        } catch {
            self.alertMessage = "Invalid Group Id"
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
