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
        ZStack {
            List(viewModel.trips) { item in
                TripView(metadata: item)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    viewModel.showingManageGroup = true
                } label: {
                    Image(systemName: "person.3")
                        .foregroundStyle(.orange)
                }
                
                Button {
                        viewModel.showingNewTrip.toggle()
                } label: {
                    Image(systemName: viewModel.showingNewTrip ? "minus" : "plus")
                        .foregroundColor( viewModel.showingNewTrip ? .red : .orange)
                        .rotationEffect(.degrees(viewModel.showingNewTrip ? 0 : 360))
                        .scaleEffect(viewModel.showingNewTrip ? 1.25 : 1.0)
                }
            }
            .blur(radius: viewModel.showingNewTrip ? 2 : 0)
            .sheet(isPresented: $viewModel.showingManageGroup) {
                ManageGroupView(presented: $viewModel.showingManageGroup, activityId: viewModel.getActivityId())
            }
            
            if viewModel.showingNewTrip {
                
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                NewTripView(activityId: viewModel.getActivityId(), newTripPresented: $viewModel.showingNewTrip)
                    .transition(AnyTransition
                        .asymmetric(insertion: .move(edge: .bottom),
                                    removal: .move(edge: .bottom))
                            .combined(with: .opacity))
                
            }
            
        }
        .animation(.default.speed(1.25), value: viewModel.showingNewTrip)
    }
}

#Preview {
        TripExpensesView(userId: "example", activityId: "Example")
}
