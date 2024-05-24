//
//  LoginViewModel.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import FirebaseAuth
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        
        // Login
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private func validate() -> Bool {
        self.errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.errorMessage = "Please fill in all fields."
            return false
        }
        
        
        guard email.contains("@") && email.contains(".") else {
            self.errorMessage = "Invalid email."
            return false
        }
        
        return true
    }
}
