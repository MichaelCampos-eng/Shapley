//
//  MainViewModel.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class MainViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                
                if let user = user {
                    self?.checkUserExistsInFirestore(uid: user.uid)
                } else {
                    self?.currentUserId = ""
                }
                //self?.currentUserId = user?.uid ?? ""
            }
            
        }
    }
    
    private func checkUserExistsInFirestore(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                self?.currentUserId = uid
            } else {
                self?.signOutUser()
            }
        }
    }
    
    private func signOutUser() {
        do {
            try Auth.auth().signOut()
            self.currentUserId = ""
        } catch let signOutError as NSError {
            print("Error signing out; %@", signOutError)
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
