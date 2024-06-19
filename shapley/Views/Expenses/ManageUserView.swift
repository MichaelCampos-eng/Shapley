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
    
    
    init(userId: String, activityId: String) {
        self._viewModel = StateObject(wrappedValue: ManageUserViewModel(user: userId, activity: activityId))
    }
    
    var body: some View {
        if viewModel.validate() {
            HStack {
                if isEditing {
                    TextField("Change Name", text: $editedName, onCommit: {
                        viewModel.updateUserName(name: editedName)
                        isEditing = false
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    VStack(alignment: .leading) {
                        Text(viewModel.getName())
                            .font(.body)
                            .bold()
                        Text(viewModel.getContact())
                            .font(.footnote)
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
            }
            .swipeActions {
                if viewModel.isRemovable {
                    Button("Remove") {
                        viewModel.removeUser()
                    }
                    .tint(Color.red)
                }
                
                if viewModel.isEditible {
                    Button("Edit") {
                        isEditing = true
                    }
                    .tint(Color.blue)
                }
                
            }
        }
    }
}

#Preview {
    ManageUserView(userId: "mKDySPyahSVrtLMjvALFxleBRm52",
             activityId: "6DE21F32-FBD8-4F26-94AC-5FA8B5EC1A5B")
}
