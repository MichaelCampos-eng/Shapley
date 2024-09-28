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
    
    init(paths: ModelPaths) {
        self._viewModel = StateObject(wrappedValue: ExpensesViewModel(paths: paths))
    }
    
    var body: some View {
        ZStack {
            Color.prussianBlue
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            viewModel.showingNewTrip.toggle()
                        }
                    } label: {
                        Image(systemName: viewModel.showingNewTrip ? "arrow.turn.up.left" : "plus")
                            .foregroundStyle(Color.white)
                            .rotationEffect(.degrees(viewModel.showingNewTrip ? 0 : 360))
                    }
                    .font(.title2)
                    .padding()
                }
                Spacer()
            }
            .zIndex(4.0)
            
            Spacer()
            if !viewModel.showingNewTrip {
                MainExpensesView()
                    .environmentObject(viewModel)
                    .transition(AnyTransition
                        .asymmetric(insertion: .move(edge: .leading),
                                    removal: .move(edge: .trailing)))
                    .zIndex(2.0)
            } else {
                NewExpenseView(activityId: viewModel.getActId(),
                               newTripPresented: $viewModel.showingNewTrip)
                .transition(AnyTransition
                    .asymmetric(insertion: .move(edge: .leading),
                                removal: .move(edge: .trailing)))
                .zIndex(2.0)
            }
        }
        .onChange(of: navigation.path) {
            if navigation.path.count == 1 {
                viewModel.beginListening()
            }
            else {
                viewModel.endListening()
            }
        }
        .sheet(isPresented: $viewModel.showingManageGroup) {
            ManageGroupView(presented: $viewModel.showingManageGroup, activityId: viewModel.getActId())
                .presentationDetents([.fraction(0.30)])
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    
        TripExpensesView(paths: ModelPaths(userId: "rXsJ8ZNOodV9acUZbxLpC8WAqry2",
                                           activityId: "FAF0D8A4-CAAD-4845-93A5-1B08EC48CA7F"))
        .environmentObject(NavigationPathStore())
}
