//
//  MainExpensesView.swift
//  shapley
//
//  Created by Michael Campos on 8/28/24.
//

import SwiftUI

struct MainExpensesView: View {
    @ObservedObject var viewModel: ExpensesViewModel
    @Binding private var onClicked: Bool
    
    init(viewModel: ExpensesViewModel, onClicked: Binding<Bool>) {
        self.viewModel = viewModel
        self._onClicked = onClicked
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Text("Expenses")
                    .bold()
                    .font(.system(size: 50, weight: .bold))
                Spacer()
            }
            .padding()
            Spacer()
            HStack {
                Button {
                    onClicked = true
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                }
                Spacer()
                Button {
                    viewModel.showingManageGroup.toggle()
                } label: {
                    Image(systemName: "person.3")
                }
            }
            .bold()
            .foregroundStyle(Color.white)
            .padding()
            Divider()
            List(viewModel.expensesMeta) { item in
                NavigationLink(value: item) {
                    ExpenseView(metadata: item)
                }
                .listRowBackground(Color.roseTaupe)
            }
            .navigationDestination(for: MetaExpense.self) { item in
                expenseView(meta: item)
            }
            .scrollContentBackground(.hidden)
            .frame(height: 300)
            .shadow(radius: 10)
            Divider()
        }
    }
    
    // TODO: change parameter for each view type
    @ViewBuilder
    private func expenseView(meta: MetaExpense) -> some View {
        switch meta.type {
        case .Bill:
            BillView(meta: ModelPaths(id: meta.id,
                                      userId: meta.userId,
                                      activityId: meta.activityId))
        case .Gas:
            GasView(meta: meta)
        case .Vendue:
            VendueView(meta: meta)
        }
    }
}

#Preview {
    MainExpensesView(viewModel: ExpensesViewModel(userId: "10b8fa78neXKKsaGdiZvbnzDCN62",
                                                  activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316"),
                     onClicked: Binding(get: {return false}, set: {_ in}))
}
