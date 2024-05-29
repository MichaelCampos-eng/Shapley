//
//  NewActivityView.swift
//  shapley
//
//  Created by Michael Campos on 5/28/24.
//

import SwiftUI

struct NewActivityView: View {
    @StateObject var viewModel = NewActivityViewModel()
    @Binding var newItemPresented: Bool
    
    var body: some View {
        VStack {
            Text("New Activity")
                .font(.system(size: 32))
                .bold()
                .padding()
            
            Form {
                TextField("Activity Name", text: $viewModel.activityName)
                    .textFieldStyle(DefaultTextFieldStyle())

                ButtonView(title: "Create",
                           background: Color.pink) {
                    
                    
                    if viewModel.canCreate {
                        viewModel.create()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
            }
            .frame(maxHeight: 200)
            
            
            
            Label(
                title: { Text("Or join a friend group!")},
                icon: { Image(systemName: "person.3.fill") }
            )
            .font(.system(size: 18))
            .bold()
    
            
            Form {
                TextField("Group ID", text: $viewModel.groupId)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                ButtonView(title: "Join Group",
                           background: Color.pink,
                           action: {
                    
                    if viewModel.canJoin {
                        viewModel.join()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                })
            }
            .frame(maxHeight: 200)
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage))
            })
            
            Spacer()
        }
    }
}

#Preview {
    NewActivityView(newItemPresented: Binding(get: {
        return true
    }, set: { _ in
        return
    }))
    
         
}
