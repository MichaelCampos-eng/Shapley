//
//  TripExpensesView .swift
//  shapley
//
//  Created by Michael Campos on 6/2/24.
//

import FirebaseFirestoreSwift
import SwiftUI

struct TripExpensesView: View {
    @StateObject var viewModel: TripExpensesViewModel
    
    init(userId: String, activityId: String) {
        self._viewModel = StateObject(wrappedValue: TripExpensesViewModel(userId: userId, activityId: activityId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.trips) { item in
                    TripView()
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Expenses")
            .toolbar {
                Button {
                    // Action
                    viewModel.showingManageGroup = true
                } label: {
                    Image(systemName: "person.3")
                        .foregroundStyle(.orange)
                }
                Button {
                    // Action
                    viewModel.showingNewTrip = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.orange)
                }
                
            }
            .sheet(isPresented: $viewModel.showingNewTrip, content: {
                NewTripView(activityId: viewModel.getActivityId(), newTripPresented: $viewModel.showingNewTrip)
            })
            .fullScreenCover(isPresented: $viewModel.showingManageGroup) {
                ManageGroupView(presented: $viewModel.showingManageGroup, activityId: viewModel.getActivityId())
            }
        }
    }
}

#Preview {
        TripExpensesView(userId: "example", activityId: "Example")
}
