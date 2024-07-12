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
    @State private var isEditing = false
    @State private var editedTitle = ""
    
    @FirestoreQuery var userActivity: [UserActivity]
    @FirestoreQuery var content: [ContentActivity]
    
    init(metadata: MetaActivity) {
        
        self._userActivity = FirestoreQuery(
            collectionPath: "users/\(metadata.userId)/activities",
            predicates: [.where("id", isEqualTo: metadata.id)])
        
        self._content = FirestoreQuery(
            collectionPath: "activities",
            predicates: [.where("id", isEqualTo: metadata.id)])
        
        self._viewModel = StateObject(
            wrappedValue: ActivityViewModel(userId: metadata.userId))
    }
    
    var body: some View { 
        
        if viewModel.validate(user: userActivity, content: content) {
            HStack {
                if isEditing {
                    TextField("Activity Title", text: $editedTitle, onCommit: {
                        viewModel.updateTitle(name: editedTitle)
                        isEditing = false
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    NavigationLink(destination: TripExpensesView(userId: viewModel.getUserId(),
                                                                 activityId: viewModel.getContentId())) {
                        VStack(alignment: .leading) {
                            Text(viewModel.getTitle())
                                .font(.body)
                                .bold()
                            Text("\(Date(timeIntervalSince1970: viewModel.getCreatedDate()).formatted(date: .abbreviated, time: .shortened))")
                                .font(.footnote)
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
            .swipeActions {
                if viewModel.isAdmin() {
                    Button("Edit") {
                        isEditing = true
                    }
                    .tint(Color.blue)
                }
                
                Button("Delete") {
                    viewModel.delete()
                }
                .tint(Color.red)
            }
        }
    }
}

#Preview {
    ActivityView(metadata: MetaActivity(userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                                        id: "6DE21F32-FBD8-4F26-94AC-5FA8B5EC1A5B",
                                        createdDate: Date().timeIntervalSince1970))
}
