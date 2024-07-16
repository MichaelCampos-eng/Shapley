//
//  TripExpensesView .swift
//  shapley
//
//  Created by Michael Campos on 6/2/24.
//

import FirebaseFirestoreSwift
import SwiftUI

struct TripExpensesView: View {
    @StateObject var viewModel: ExpensesViewModel
    
    init(userId: String, activityId: String) {
        self._viewModel = StateObject(wrappedValue: ExpensesViewModel(userId: userId,
                                                                          activityId: activityId))
    }
    
    var body: some View {
        ZStack {
            List(viewModel.expensesMeta) { item in
                ExpenseView(metadata: item)
            }
            .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            .listStyle(PlainListStyle())
            .navigationTitle("Expenses")
            .toolbarBackground(Color.black, for: .tabBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    viewModel.showingManageGroup = true
                } label: {
                    Image(systemName: "person.3")
                        .foregroundStyle(.orange)
                }
                Button {
                    withAnimation {
                        viewModel.showingNewTrip.toggle()
                    }
                } label: {
                    Image(systemName: viewModel.showingNewTrip ? "arrow.turn.right.up" : "plus")
                        .foregroundColor( viewModel.showingNewTrip ? .red : .orange)
                        .rotationEffect(.degrees(viewModel.showingNewTrip ? 0 : 360))
                }
            }
            .blur(radius: viewModel.showingNewTrip ? 2 : 0)
            .sheet(isPresented: $viewModel.showingManageGroup) {
                ManageGroupView(presented: $viewModel.showingManageGroup, activityId: viewModel.getActivityId())
            }
            
            if viewModel.showingNewTrip {
                
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .zIndex(2.0)
                
                NewExpenseView(activityId: viewModel.getActivityId(), 
                               newTripPresented: $viewModel.showingNewTrip)
                    .transition(
                        AnyTransition
                        .asymmetric(insertion: .move(edge: .top),
                                    removal: .move(edge: .top))
                        .combined(with: .opacity))
                    .zIndex(3.0)
            }
            
        }
        .animation(.default.speed(1.0), value: viewModel.showingNewTrip)
    }
}

#Preview {
        TripExpensesView(userId: "example", activityId: "Example")
}
