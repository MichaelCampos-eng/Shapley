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
    @EnvironmentObject private var navigation: NavigationPathStore
    
    init(userId: String, activityId: String) {
        self._viewModel = StateObject(wrappedValue: ExpensesViewModel(userId: userId,
                                                                          activityId: activityId))
    }
    
    var body: some View {
        ZStack {
            List(viewModel.expensesMeta) { item in
                NavigationLink(value: item) {
                    ExpenseView(metadata: item)
                }
            }
            .navigationDestination(for: MetaExpense.self) { item in
                expenseView(meta: item)
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
                    .presentationDetents([.fraction(0.30)])
            }
            .onChange(of: navigation.path) {
                if navigation.path.count == 1 {
                    viewModel.beginListening()
                }
                else {
                    viewModel.endListening()
                }
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
        .animation(.default, value: viewModel.showingNewTrip)
    }
    
    // TODO: change parameter for each view type
    @ViewBuilder
    private func expenseView(meta: MetaExpense) -> some View {
        switch meta.type {
        case .Bill:
            BillView(meta: ModelPaths(id: meta.id,
                                      userId: meta.userId,
                                      activityId: meta.userId))
        case .Gas:
            GasView(meta: meta)
        case .Vendue:
            VendueView(meta: meta)
        }
    }
}

#Preview {
        TripExpensesView(userId: "mKDySPyahSVrtLMjvALFxleBRm52", activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316")
}
