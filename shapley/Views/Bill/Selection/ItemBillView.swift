//
//  BillItemView.swift
//  shapley
//
//  Created by Michael Campos on 7/16/24.
//

import SwiftUI
import Combine

struct ItemBillView: View {
    @StateObject private var viewModel: ItemBillViewModel
    @State private var isShifted: Bool = false
    private var isFirst: Bool
    
    private let rightSymbols: [ActionSymbol] = [ActionSymbol(color: .clear,
                                                             name: "Remove",
                                                             systemIcon: "arrow.left"),
                                                ActionSymbol(color: .red,
                                                             name: "Remove from cart",
                                                             systemIcon: "cart.badge.minus")]
    private let leftSymbols: [ActionSymbol] = [ActionSymbol(color: .clear,
                                                            name: "Add",
                                                            systemIcon: "arrow.right"),
                                               ActionSymbol(color: .orange,
                                                            name: "Add to cart",
                                                            systemIcon: "cart.badge.plus")]
    
    init(claim: Claim,
         updateAction: @escaping (String, Int) async -> Void,
         isFirst: Bool) {
        self._viewModel = StateObject(wrappedValue: ItemBillViewModel(claim: claim,
                                                                      action: updateAction))
        self.isFirst = isFirst
    }
    
    var body: some View {
        @State var showInsights: Bool = false
        SwipeActionsView(right: SwipeAction(meta: rightSymbols,
                                            execute: viewModel.subtract),
                         left: SwipeAction(meta: leftSymbols,
                                           execute: viewModel.add)) {
            InsightsBillView(item: viewModel.claim.sale, selected: viewModel.selected)
                .padding(.vertical)
                .padding(.trailing)
            .offset(x: !isShifted ? 0 : 40)
            .animation(.bouncy(duration: 1.0), value: isShifted)
            .onAppear {
                if isFirst {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isShifted = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isShifted = false
                        }
                    }
                }
            }
        }
        Divider()
    }
}

#Preview {
    ItemBillView(claim: Claim(sale: Sale(id: "",
                                         name: "Mango",
                                         quantity: 12,
                                         price: 35.88),
                              quantityClaimed: 2),
                 updateAction: {_, _ in},
                 isFirst: true)
}
