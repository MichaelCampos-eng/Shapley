//
//  LoginView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                
                HeaderView(title: "Shapley",
                           subtitle: "Make your road trips fair",
                           angle: 15,
                           background: Color.teal)
                    .padding(.bottom, 5)
                    .padding()
                
                // Login Form
                Form {
                    
                    // Incorrect log in
              
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    
                    
                    TextField("Email Address",  text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    
                    ButtonView(title: "Log In",
                               background: Color.blue,
                               action: viewModel.login)
                    
                    // Alternative way for button, this one definitely works
//                    ButtonView(title: "Login In",
//                               background: Color.red) {
//                                viewModel.login()
//                    }
                }
                
                // Create an account
                
                VStack {
                    Text("New around here?")
                    
                    NavigationLink("Create An Account", destination: RegisterView())
                    
                }
                
                
            }
        }
        
    }
}

#Preview {
    LoginView()
}
