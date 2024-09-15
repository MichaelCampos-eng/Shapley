//
//  UserView.swift
//  shapley
//
//  Created by Michael Campos on 6/17/24.
//

import FirebaseFirestore
import SwiftUI

struct ManageUserView: View {
    @StateObject var viewModel: ManageUserViewModel
    @State private var isEditing = false
    @State private var editedName = ""
    @State private var showingOptions: Bool = false
    
    init(userId: String, activityId: String, completion: @escaping (String, String) -> Void) {
        self._viewModel = StateObject(wrappedValue: ManageUserViewModel(user: userId,
                                                                        activity: activityId,
                                                                        update: completion))
    }
    
    var body: some View {
        
        let screenSize = UIScreen.main.bounds.size
        let diameter = min(screenSize.width, screenSize.height) / 3
        
        if viewModel.validate() {
  
                    Rectangle()
                        .fill(Material.ultraThin)
                        .frame(width: diameter, height: diameter)
                        .cornerRadius(20)
                        .overlay {
                            ZStack{
                                if viewModel.isEditible || viewModel.isRemovable {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Button(action: {
                                                showingOptions.toggle()
                                                isEditing = false
                                            }, label: {
                                                Image(systemName: "ellipsis")
                                                    .foregroundStyle(Color.white)
                                            })
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .zIndex(3.0)
                                }
                                if isEditing {
                                    HStack {
                                        Image(systemName: "person")
                                        TextField("Change Name", text: $editedName)
                                            .onSubmit {
                                                viewModel.updateUserName(name: editedName)
                                                isEditing = false
                                                showingOptions = false
                                            }
                                    }
                                    .zIndex(2.0)
                                    .padding()
                                } else {
                                    if !showingOptions {
                                        VStack(alignment: .center) {
                                            Text(viewModel.getName())
                                                .foregroundStyle(Color.white)
                                                .font(.body)
                                                .bold()
                                            if viewModel.isAdmin() {
                                                Text("Admin")
                                                    .font(.footnote)
                                                    .foregroundStyle(Color(.secondaryLabel))
                                            }
                                            Text(viewModel.getContact())
                                                .font(.footnote)
                                                .foregroundStyle(Color(.secondaryLabel))
                                        }
                                        .zIndex(1.0)
                                    } else {
                                        VStack {
                                            if viewModel.isEditible {
                                                HStack {
                                                    Spacer()
                                                    Text("Edit")
                                                        .bold()
                                                        .foregroundStyle(Color.white)
                                                    Spacer()
                                                }
                                                .padding()
                                                .background {
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .fill(Color.blue)
                                                }
                                                .onTapGesture {
                                                    isEditing = true
                                                }
                                            }
                                            if viewModel.isRemovable {
                                                HStack {
                                                    Spacer()
                                                    Text("Remove")
                                                        .bold()
                                                        .foregroundStyle(Color.white)
                                                    Spacer()
                                                }
                                                .padding()
                                                .background {
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .fill(Color.red)
                                                }
                                                .onTapGesture {
                                                    viewModel.removeUser()
                                                }
                                            }
                                        }
                                        .padding()
                                        .zIndex(1.0)
                                    }
                                }
                            }
                        }
        }
    }
}

#Preview {
    ManageUserView(userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                   activityId: "6DE21F32-FBD8-4F26-94AC-5FA8B5EC1A5B") {a, b in
        print(a)
    }
}
