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
    @FirestoreQuery var items: [Activity]
    
    
    
    // Might have to update path for group sessions
    init(userId: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/todos")
        
        self._viewModel = StateObject(
            wrappedValue: ActivitiesViewModel(userId: userId))
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                List(items) { item in
                    ActivityView(activity: item)
                        .swipeActions {
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
                }
            }
            .sheet(isPresented: $viewModel.showingNewActivity) {
                NewActivityView(newItemPresented: $viewModel.showingNewActivity)
            }
        }
    }
}

#Preview {
    ActivitiesView(userId: "RigPlWygk9NOJOwSNhaJ8QfGBv22")
}
