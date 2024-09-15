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
    @State private var onClickedDismiss = false
    
    @EnvironmentObject private var navigation: NavigationPathStore
    @Environment(\.dismiss ) private var dismiss
    
    init(userId: String, activityId: String) {
        self._viewModel = StateObject(wrappedValue: ExpensesViewModel(userId: userId,
                                                                          activityId: activityId))
    }
    
    var body: some View {
        ZStack {
            Color.prussianBlue
                .ignoresSafeArea()
            if !viewModel.showingNewTrip {
                MainExpensesView(viewModel: viewModel, onClicked: $onClickedDismiss)
                    .transition(AnyTransition
                        .asymmetric(insertion: .move(edge: .leading),
                                    removal: .move(edge: .trailing)))
                    .zIndex(2.0)
            } else {
                NewExpenseView(activityId: viewModel.getActivityId(),
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
        .onChange(of: onClickedDismiss) { old, new in
            if old == false && new == true {
                dismiss()
            }
        }
        .sheet(isPresented: $viewModel.showingManageGroup) {
            ManageGroupView(presented: $viewModel.showingManageGroup, activityId: viewModel.getActivityId())
                .presentationDetents([.fraction(0.30)])
        }
        .toolbar {
            Button {
                withAnimation {
                    viewModel.showingNewTrip.toggle()
                }
            } label: {
                Image(systemName: viewModel.showingNewTrip ? "arrow.turn.up.left" : "plus")
                    .foregroundStyle(Color.white)
                    .rotationEffect(.degrees(viewModel.showingNewTrip ? 0 : 360))
            }
        }
        .navigationTitle(viewModel.titleName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
        TripExpensesView(userId: "10b8fa78neXKKsaGdiZvbnzDCN62", activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316")
        .environmentObject(NavigationPathStore())
}
