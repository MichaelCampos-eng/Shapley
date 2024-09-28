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
    @Published var user: UserActivity?
    @Published var content: ContentActivity?
    
    private var userReg: ListenerRegistration?
    private var contentsReg: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    private var meta: MetaActivity
    
    init(meta: MetaActivity) {
        self.meta = meta
        self.beginListening()
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
    
    private func fetchUser() {
        let db = Firestore.firestore()
        userReg = db.collection("users/\(getUserId())/activities/").document(getActId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: UserActivity.self) else {
                print("User does not exist.")
                return
            }
            self?.user = document
        }
    }
    
    private func fetchContent() {
        let db = Firestore.firestore()
        contentsReg = db.collection("activities").document(getActId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: ContentActivity.self) else {
                print("Activity does not exist.")
                return
            }
            self?.content = document
        }
    }
    
    func updateTitle(name: String) {
        let db = Firestore.firestore()
        let document = db.collection("activities").document(getActId())
     
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
            .document(getActId())
        document.delete()
        
        if let user {
            if user.isAdmin {
                db.collection("activities")
                    .document(getActId())
                    .delete()
            }
        }
    }
    
    func isAvailable() -> Bool {
        if user != nil, content != nil {
            return true
        }
        return false
    }
    
    func getUserId() -> String {
        return meta.paths.userId!
    }
    
    func getActId() -> String {
        return meta.paths.activityId!
    }
}
    

