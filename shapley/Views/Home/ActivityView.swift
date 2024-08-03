//
//  ItemView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import FirebaseFirestore
import SwiftUI

struct ActivityView: View {
    @StateObject var viewModel: ActivityViewModel
    @State private var isEditing: Bool = false
    @State private var editedTitle: String = ""

    init(metadata: MetaActivity) {
        self._viewModel = StateObject(
            wrappedValue: ActivityViewModel(meta: metadata))
    }
    
    var body: some View { 
        if viewModel.isAvailable() {
            HStack {
                if isEditing {
                    TextField(editedTitle, text: $editedTitle, onCommit: {
                        viewModel.updateTitle(name: editedTitle)
                        isEditing = false
                    })
                    .foregroundStyle(Color(.secondaryLabel))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    VStack(alignment: .leading) {
                        Text(viewModel.getTitle())
                            .font(.body)
                            .bold()
                        Text("\(Date(timeIntervalSince1970: viewModel.getCreatedDate()).formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote)
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
            .onAppear {
                editedTitle = viewModel.getTitle()
            }
            .swipeActions {
                if viewModel.isAdmin() && !isEditing {
                    Button("Edit") {
                        isEditing = true
                    }
                    .tint(Color.blue)
                }
                if !isEditing {
                    Button("Delete") {
                        viewModel.delete()
                    }
                    .tint(Color.red)
                }
            }
        }
    }
}

#Preview {
    ActivityView(metadata: MetaActivity(userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                                        id: "6DE21F32-FBD8-4F26-94AC-5FA8B5EC1A5B",
                                        createdDate: Date().timeIntervalSince1970))
}
