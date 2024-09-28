//
//  MainExpensesView.swift
//  shapley
//
//  Created by Michael Campos on 8/28/24.
//

import SwiftUI

struct MainExpensesView: View {
    @EnvironmentObject private var viewModel: ExpensesViewModel
    @Environment(\.dismiss ) private var dismiss
    @State private var onClickedDismiss = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text(viewModel.title)
                    .bold()
                    .font(.headline)
                    .foregroundStyle(Color(.secondaryLabel))
                    .padding()
                Spacer()
            }
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("Expenses")
                        .bold()
                        .font(.system(size: 50, weight: .bold))
                        .shadow(radius: 10)
                    Text("Tap or swipe left")
                        .bold()
                        .foregroundStyle(Color(.secondaryLabel))
                }
                Spacer()
            }
            .padding()
            Spacer()
            HStack {
                Button {
                    onClickedDismiss = true
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
            List(viewModel.expensesMeta, id: \.paths.modelId) { item in
                NavigationLink(value: item) {
                    ExpenseView(metadata: item)
                }
                .listRowBackground(Color.roseTaupe)
            }
            .navigationDestination(for: MetaExpense.self) { item in
                switch item.type {
                case .Bill:
                    BillView(meta: item.paths)
                case .Gas:
                    GasView(meta: item)
                case .Vendue:
                    VendueView(meta: item)
                }
            }
            .scrollContentBackground(.hidden)
            .frame(height: 300)
            .shadow(radius: 10)
            Divider()
        }
        .onChange(of: onClickedDismiss) { old, new in
            if old == false && new == true {
                dismiss()
            }
        }
    }
}

#Preview {
    MainExpensesView()
        .environmentObject(ExpensesViewModel(paths: ModelPaths(modelId: "UEiWyvP90F69eAttZDRM",
                                                               userId: "rXsJ8ZNOodV9acUZbxLpC8WAqry2",
                                                               activityId: "FAF0D8A4-CAAD-4845-93A5-1B08EC48CA7F")))
}
