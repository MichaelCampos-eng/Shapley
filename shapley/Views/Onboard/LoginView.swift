//
//  LoginView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @FocusState private var emailFieldIsFocused: Bool
    
    var body: some View {
        
            NavigationView {
                VStack {
                    HeaderView(title: "Shapley",
                               subtitle: "Fair expense sharing",
                               angle: 15)
                    Spacer()
                    
                    Form {
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(Color.red)
                        }
                        TextField("Email Address",  text: $viewModel.email)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocapitalization(.none)
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocapitalization(.none)
                        
                        ButtonView(title: "Log In",
                                   background: Color.orange,
                                   action: viewModel.login)
                    }
                    .scrollContentBackground(.hidden)
                    Spacer()
                    
                    VStack {
                        Text("New around here?")
                            .foregroundStyle(Color.orange)
                        NavigationLink("Create an Account", destination: RegisterView())
                    }
                    .padding()
                    .ignoresSafeArea(.keyboard)
                }
            }
        }
}

#Preview {
    LoginView()
}
