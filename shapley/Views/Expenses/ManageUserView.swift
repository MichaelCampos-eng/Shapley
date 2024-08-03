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
    
    init(userId: String, activityId: String, completion: @escaping (String, String) -> Void) {
        self._viewModel = StateObject(wrappedValue: ManageUserViewModel(user: userId,
                                                                        activity: activityId,
                                                                        update: completion))
    }
    
    var body: some View {
        
        let screenSize = UIScreen.main.bounds.size
        let diameter = min(screenSize.width, screenSize.height) / 3
        
        if viewModel.validate() {
            HStack {
                if isEditing {
                    TextField("Change Name", text: $editedName, onCommit: {
                        viewModel.updateUserName(name: editedName)
                        isEditing = false
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    ZStack{
                        Image(systemName: "person")
                            .tint(.orange)
                        Rectangle()
                            .fill(Material.ultraThin)
                            .frame(width: diameter, height: diameter)
                            .cornerRadius(20)
                            .overlay {
                                VStack(alignment: .center) {
                                    Text(viewModel.getName())
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
                            }
                    }
                    
                }
            }
//            .swipeActions {
//                if viewModel.isRemovable {
//                    Button("Remove") {
//                        viewModel.removeUser()
//                    }
//                    .tint(Color.red)
//                }
//                
//                if viewModel.isEditible {
//                    Button("Edit") {
//                        isEditing = true
//                    }
//                    .tint(Color.blue)
//                }
//                
//            }
        }
//            .scrollTransition(.interactive,
//                              axis: .horizontal) { view, phase in
//                view.opacity(phase.value > 0 ? 0 : 1.0)
//                    .offset(x: phase.value > 0 ? 500 : 0)
//                    .blur(radius: phase.value > 0 ? 15 : 0)
//                    .rotationEffect(.degrees(phase.value > 0 ? -90 : 0))
//            }
    }
}

#Preview {
    ManageUserView(userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                   activityId: "6DE21F32-FBD8-4F26-94AC-5FA8B5EC1A5B") {a, b in
        print(a)
    }
}
