//
//  RegisterView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            // Header
            HeaderView(title: "Register",
                       subtitle: "Start planning trips",
                       angle: -15)
            Spacer()
            
            Form {
                TextField("Full Name", text: $viewModel.name)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                TextField("Email Address", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                TextField("Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                ButtonView(title: "Create Account",
                           background: Color.orange,
                            action: { viewModel.register()
                })
                
            }
            .scrollContentBackground(.hidden)
            Spacer()
        }
        
        
    }
}

#Preview {
    RegisterView()
}
