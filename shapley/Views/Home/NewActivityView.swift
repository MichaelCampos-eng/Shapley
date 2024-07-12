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
    @State var createActivity: Bool = true
    @State var joinActivity: Bool = false
    @Namespace private var animationSpacespace
    
    var body: some View {
        
        VStack {
            Spacer()
            SliderActivityView(createActivity: $createActivity, joinActivity: $joinActivity)
                .padding(.vertical, 20)
            Divider()
            
            ZStack {
                if createActivity {
                    VStack {
                        
                        Form {
                            Section(header: Text("New Activity").font(.headline)) {
                                TextField("Activity Name", text: $viewModel.activityName)
                                    .textFieldStyle(DefaultTextFieldStyle())
                                
                                ButtonView(title: "Create",
                                           background: Color.orange) {
                                    
                                    
                                    if viewModel.canCreate {
                                        viewModel.create()
                                        newItemPresented = false
                                    } else {
                                        viewModel.showAlert = true
                                    }
                                }
                            }
                        }
                        
                    }
                    .matchedGeometryEffect(id: "content", in: animationSpacespace)
                    .frame(height: 200)
                    Spacer()
                    
                } else {
                    VStack {
                        Form {
                            Section(header: Text("Join Group!").font(.headline)) {
                                
                                TextField("Group ID", text: $viewModel.groupId)
                                    .textFieldStyle(DefaultTextFieldStyle())
                                
                                ButtonView(title: "Join Group",
                                           background: Color.orange,
                                           action: {
                                    
                                    if viewModel.canJoin {
                                        viewModel.join()
                                        newItemPresented = false
                                    } else {
                                        viewModel.showAlert = true
                                    }
                                })
                            }
                        }
                    }
                    .frame(height: 200)
                    .matchedGeometryEffect(id: "content", in: animationSpacespace)
                    Spacer()
                }
            }
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage))
            })
            .animation(.smooth, value: createActivity)
            .animation(.spring, value: joinActivity)
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
