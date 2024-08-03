//
//  GroupSaleEntries.swift
//  shapley
//
//  Created by Michael Campos on 8/1/24.
//

import SwiftUI

struct GroupSaleEntriesView: View {
    
    private var items: [Sale]
    
    init(sales: [Sale]) {
        self.items = sales
    }
    
    var body: some View {
        let columns = [GridItem(.flexible(), alignment: .topLeading),
                       GridItem(.flexible(), alignment: .top),
                       GridItem(.flexible(), alignment: .topTrailing)]
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                Group {
                    Text("Item")
                    Text("Count")
                    Text("Price")
                }
                .font(.subheadline)
                .foregroundStyle(Color(.secondaryLabel))
                ForEach(items) { item in
                    Text(item.name)
                    Text(String(item.quantity))
                    Text(String(format: "%.2f", item.price))
                }
                .font(.callout)
                .bold()
            }
        }
    }
}

#Preview {
    GroupSaleEntriesView(sales:  [.init(id: "a", name: "apples", quantity: 2, price: 1.99),
                                  .init(id: "b", name: "orange", quantity: 1, price: 3.99),
                                  .init(id: "c", name: "bananas", quantity: 4, price: 2.99),
                                  .init(id: "d", name: "melons", quantity: 3, price: 9.99),
                         .init(id: "asd", name: "apples", quantity: 2, price: 1.99),
                                                       .init(id: "asf", name: "orange", quantity: 1, price: 3.99),
                                                       .init(id: "asf", name: "bananas", quantity: 4, price: 2.99),
                                                       .init(id: "sfd", name: "melons", quantity: 3, price: 9.99)])
}
