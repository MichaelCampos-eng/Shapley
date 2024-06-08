//
//  ActivitiesView.swift
//  shapley
//
//  Created by Michael Campos on 5/28/24.
//


import FirebaseFirestoreSwift
import SwiftUI

struct ActivitiesView: View {
    @StateObject var viewModel: ActivitiesViewModel
    
    // TODO: Incorporate group session join
    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue: ActivitiesViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.metadata) { item in
                
                    
                    // TODO: With ActivityUser, use the activity id to access shared data
                    ActivityView(metadata: item)
                        .swipeActions {
                            Button("Edit") {
                                // TODO: Add some function to edit
                            }
                            .tint(Color.blue)
                            Button("Delete") {
                                viewModel.delete(id: item.id)
                            }
                            .tint(Color.red)
                        }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Activities")
            .toolbar {
                Button {
                    // Action
                    viewModel.showingNewActivity = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.orange)
                }
            }
            .sheet(isPresented: $viewModel.showingNewActivity) {
                NewActivityView(newItemPresented: $viewModel.showingNewActivity)
            }
        }
    }
}

#Preview {
    ActivitiesView(userId: "10b8fa78neXKKsaGdiZvbnzDCN62")
}
