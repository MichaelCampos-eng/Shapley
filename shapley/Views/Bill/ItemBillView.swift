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
  
    private let saleItem: Sale
    private let unitPrice: Double
    
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
         updateAction: @escaping (String, Int) -> Void) {
        self.saleItem = sale
        self.unitPrice = Double(String(format: "%.2f", sale.price / Double(sale.quantity))) ?? 0.0
        self._viewModel = StateObject(wrappedValue: ItemBillViewModel(selectedQuantity: user.claims[sale.id],
                                                                      saleItem: sale,
                                                                      action: updateAction))
    }
    
    var body: some View {
        SwipeActionsView(right: SwipeAction(meta: rightSymbols, 
                                            execute: viewModel.subtract),
                         left: SwipeAction(meta: leftSymbols, 
                                           execute: viewModel.add)) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(saleItem.name)")
                    Text("Total: \(String(format: "%.2f", saleItem.price))")
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))
                    Text("Unit Price: \(String(format: "%.2f", unitPrice))")
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))
                }
                Spacer() 
                
                HStack{
                    Text("\(viewModel.selected)")
                        .foregroundStyle(.orange)
                    Text("/  \(saleItem.quantity)")
                }
                
                Spacer()
                Text("\(String(format: "%.2f", Double(viewModel.selected) * unitPrice))")
            }
        }
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
                 updateAction: {_, _ in})
}
