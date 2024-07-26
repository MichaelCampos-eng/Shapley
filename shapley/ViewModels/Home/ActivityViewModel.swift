//
//  ActivityViewModel.swift
//  shapley
//
//  Created by Michael Campos on 6/10/24.
//

import FirebaseFirestore
import Combine
import Foundation

class ActivityViewModel: ObservableObject {
    @Published private var user: UserActivity?
    @Published private var content: ContentActivity?
    
    private var userReg: ListenerRegistration?
    private var contentsReg: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    private var activityData: MetaActivity
    
    init(meta: MetaActivity) {
        self.activityData = meta
        self.beginListening()
    }
    
    private func fetchUser() {
        let db = Firestore.firestore()
        userReg = db.collection("users/\(getUserId())/activities/").document(getContentId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: UserActivity.self) else {
                print("User does not exist.")
                return
            }
            self?.user = document
        }
    }
    
    private func fetchContent() {
        let db = Firestore.firestore()
        contentsReg = db.collection("activities").document(getContentId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: ContentActivity.self) else {
                print("Activity does not exist.")
                return
            }
            self?.content = document
        }
    }
    
    func updateTitle(name: String) {
        let db = Firestore.firestore()
        let document = db.collection("activities").document(getContentId())
     
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
    
    func delete() {
        let db = Firestore.firestore()
        let document = db.collection("users")
            .document(getUserId())
            .collection("activities")
            .document(getContentId())
        document.delete()
        
        if self.isAdmin() {
            db.collection("activities")
                .document(getContentId())
                .delete()
        }
    }
    
    func beginListening() {
        self.fetchUser()
        self.fetchContent()
    }
    
    func endListening() {
        userReg?.remove()
        contentsReg?.remove()
        userReg = nil
        contentsReg = nil
    }
    
    func isAvailable() -> Bool {
        if user != nil, content != nil {
            return true
        }
        return false
    }
    
    func getUserId() -> String {
        return self.activityData.userId
    }
    
    func getContentId() -> String {
        return self.activityData.id
    }
    
    func isAdmin() -> Bool {
        return user!.isAdmin
    }
    
    func getTitle() -> String {
        return content!.title
    }
    
    func getCreatedDate() -> TimeInterval {
        return content!.createdDate
    }
}
    

