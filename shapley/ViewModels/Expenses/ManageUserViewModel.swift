//
//  UserViewModel.swift
//  shapley
//
//  Created by Michael Campos on 6/18/24.
//

import Combine
import FirebaseFirestore
import Foundation
import FirebaseAuth

class ManageUserViewModel: ObservableObject {
    @Published var isRemovable: Bool = false
    @Published var isEditible: Bool = false
    
    @Published private var userInfo: User?
    @Published private var userActivity: UserActivity?
    @Published private var userMeta: ManageUser?
    @Published private var userCurrent: UserActivity?
    
    private var completion: (String, String) -> Void
    private let userId: String
    private let activityId: String
    private var cancellables = Set<AnyCancellable>()
    
    init(user: String, activity: String, update: @escaping (String, String) -> Void) {
        self.userId = user
        self.activityId = activity
        self.completion = update
        
        self.fetchUserInfo()
        self.fetchUserActivity()
        self.fetchUserMeta()
        
        self.storeIdName()
        
        self.fetchCurrentAdmin()
        self.fetchIsRemovable()
        self.fetchIsEditable()
    }
    
    public func updateUserName(name: String) {
        let db = Firestore.firestore()
        let document = db.collection("users/\(self.userId)/activities").document(self.activityId)
        
        document.getDocument(as: UserActivity.self) { result in
            switch result {
            case .success(let userData):
                var updated = userData
                updated.changeTempName(name)
                document.setData(updated.asDictionary()) { error in
                    if let error = error {
                        print("Error saving document: \(error.localizedDescription)")
                    } else {
                        print("Document sucessfully updated")
                    }
                }
            case .failure(let error):
                print("Error encoding: \(error.localizedDescription)")
            }
        }
    }
    
    public func removeUser() {
        // Delete reference to activity
        let db = Firestore.firestore()
        let userActivity = db.collection("users/\(self.userId)/activities")
            .document(self.activityId)
        userActivity.delete()
        
        // Update activity content valid users
        let activityDocument = db.collection("activities")
            .document(self.activityId)
        
        activityDocument.getDocument(as: ContentActivity.self) { result in
            switch result {
            case .success(let contentActivity):
                var updated = contentActivity
                updated.removeUser(self.userId)
                activityDocument.setData(updated.asDictionary()) { error in
                    if let error = error {
                        print("Error saving document: \(error.localizedDescription)")
                    } else {
                        print("Document sucessfully updated!")
                    }
                }
            case .failure(let error):
                print("Error encoding: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchIsEditable() {
        $userInfo
            .sink { [weak self] user in
                guard let uId = Auth.auth().currentUser?.uid else {
                    return
                }
                guard let user = user else {
                    return
                }
                if uId == user.id {
                    self?.isEditible = true
                } else {
                    self?.isEditible = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchIsRemovable() {
        Publishers.CombineLatest($userActivity, $userCurrent)
            .map { user, current in
                guard let user = user else {
                    return false
                }
                guard let current = current else {
                    return false
                }
                return !user.isAdmin && current.isAdmin
            }
            .assign(to: \.isRemovable, on: self)
            .store(in: &cancellables)
    }
    
    private func fetchCurrentAdmin() {
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users/\(uId)/activities").document(self.activityId).addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                print("Activity for user does not exist.")
                return
            }
            self?.userCurrent = try? snapshot.data(as: UserActivity.self)
        }
    }
    
    public func getId() -> String {
        return self.userId
    }
    
    public func getName() -> String {
        if let meta = userMeta {
            return meta.userName
        }
        return "User"
    }
    
    public func isAdmin() -> Bool {
        if let meta = userMeta {
            return meta.isAdmin
        }
        return false
    }
    
    public func getContact() -> String {
        return userMeta?.contact ?? "Contact"
    }
    
    public func validate() -> Bool {
        guard self.userMeta != nil else {
            return false
        }
        return true
    }

    private func fetchUserInfo() {
        let db = Firestore.firestore()
        db.collection("users").document(self.userId).addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching user info")
                return;
            }
            self?.userInfo = try? snapshot.data(as: User.self)
        }
    }
    
    private func fetchUserActivity() {
        let db = Firestore.firestore()
        db.collection("users/\(userId)/activities").document(self.activityId).addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching user activity")
                return
            }
            self?.userActivity = try? snapshot.data(as: UserActivity.self)
        }
    }
    
    private func storeIdName() {
        $userActivity
            .sink { [weak self] activity in
                guard let id = self?.userId else {
                    return
                }
                guard let name = activity?.tempName else {
                    return
                }
                self?.completion(id, name)
            }
            .store(in: &cancellables)
    }
        
    private func fetchUserMeta() {
        Publishers.CombineLatest($userInfo, $userActivity)
            .map { [weak self] info, activity in
                return self?.generateUserMeta(user: info, activity: activity)
                
            }
            .assign(to: \.userMeta, on: self)
            .store(in: &cancellables)
    }
    
    private func generateUserMeta(user: User?, activity: UserActivity?) -> ManageUser? {
        guard let user = user else {
            return nil
        }
        guard let activity = activity else {
            return nil
        }
        return ManageUser(id: user.id, 
                          userName: activity.tempName,
                          contact: user.email,
                          isAdmin: activity.isAdmin)
    }
}
