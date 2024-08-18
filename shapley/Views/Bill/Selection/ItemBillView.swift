//
//  BillItemView.swift
//  shapley
//
//  Created by Michael Campos on 7/16/24.
//

import SwiftUI
import Combine

struct InterimSale {
    let sale: Sale
    let unitPrice: Double
}

struct ItemBillView: View {
    @StateObject private var viewModel: ItemBillViewModel
    @State private var isShifted: Bool = false
    private var isFirst: Bool
  
    private let saleItem: InterimSale
    
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
    
    init(sale: Sale,
         user: UserBill,
         updateAction: @escaping (String, Int) -> Void,
         isFirst: Bool) {
        let unitPrice = Double(String(format: "%.2f", sale.price / Double(sale.quantity))) ?? 0.0
        self.saleItem = InterimSale(sale: sale, unitPrice: unitPrice)
        
        self._viewModel = StateObject(wrappedValue: ItemBillViewModel(selectedQuantity: user.claims[sale.id],
                                                                      saleItem: sale,
                                                                      action: updateAction))
        self.isFirst = isFirst
    }
    
    var body: some View {
        
        @State var showInsights: Bool = false
        
        SwipeActionsView(right: SwipeAction(meta: rightSymbols,
                                            execute: viewModel.subtract),
                         left: SwipeAction(meta: leftSymbols,
                                           execute: viewModel.add)) {
            InsightsBillView(item: saleItem, selected: viewModel.selected)
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
    ItemBillView(sale: Sale(id: "",
                            name: "Mango",
                            quantity: 12,
                            price: 35.88),
                 user: UserBill(owner: false,
                                claims: ["":3],
                                createdDate: TimeInterval()),
                 updateAction: {_, _ in},
                 isFirst: true)
}
