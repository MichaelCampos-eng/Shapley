//
//  BillItemView.swift
//  shapley
//
//  Created by Michael Campos on 7/16/24.
//

import SwiftUI

struct ItemBillView: View {
    
    private let saleItem: Sale
    private let unitPrice: Double
    private var selected: Double
    private let rightSwipe: Action
    private let leftSwipe: Action
    
    init(sale: Sale,
         user: UserBill,
         addAction: @escaping (String) -> Void,
         removeAction:  @escaping (String) -> Void) {
        
        self.saleItem = sale
        self.unitPrice = Double(String(format: "%.2f", sale.price / Double(sale.quantity))) ?? 0.0
        if let val = user.claims[sale.id] {
            self.selected = Double(val)
        } else {
            self.selected = 0.0
        }
        rightSwipe = Action(
                            meta: [
                                ActionSymbol(color: .clear,
                                             name: "Remove",
                                             systemIcon: "arrow.left"),
                                ActionSymbol(color: .red,
                                             name: "Remove from cart",
                                             systemIcon: "cart.badge.minus")],
                            execute: removeAction)
        leftSwipe = Action(
                            meta: [
                                ActionSymbol(color: .clear,
                                             name: "Add",
                                             systemIcon: "arrow.right"),
                                ActionSymbol(color: .orange,
                                             name: "Add to cart",
                                             systemIcon: "cart.badge.plus")],
                            execute: addAction)
    }
    
    var body: some View {
        SwipeActionsView(right: rightSwipe, left: leftSwipe, parameterAction: saleItem.id) {
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
                Text("\(Int(selected))/\(saleItem.quantity)")
                Spacer()
                Text("\(String(format: "%.2f", self.selected * self.unitPrice))")
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
                 addAction: {_ in},
                 removeAction: {_ in})
}
