//
//  InsightsBillView.swift
//  shapley
//
//  Created by Michael Campos on 8/16/24.
//

import SwiftUI

struct InsightsBillView: View {
    
    @State var showInsights: Bool = false
    private let item: InterimSale
    private let selected: Int
    
    init(item: InterimSale, selected: Int) {
        self.item = item
        self.selected = selected
    }
    
    var body: some View {
        HStack {
            
            Image(systemName: showInsights ? "bag.circle.fill" : "bag.circle")
                .font(.title)
                .onTapGesture(count: 2, perform: {
                    withAnimation {
                        showInsights.toggle()
                    }
                })
            
            VStack(alignment: .leading) {
                Text("\(item.sale.name)")
                if !showInsights {
                    Text("$\(String(format: "%.2f", Double(selected) * item.unitPrice))")
                        .font(.footnote)
                        .bold()
                }
                if showInsights {
                    
                    HStack(alignment: .center) {
                        Text("$\(String(format: "%.2f", item.sale.price)) Total")
                            .font(.footnote)
                            .foregroundStyle(Color(.secondaryLabel))
                        Image(systemName: "arrow.right")
                            .font(.footnote)
                            .foregroundStyle(Color(.secondaryLabel))
                        Text("$\(String(format: "%.2f", item.unitPrice)) UP")
                            .font(.footnote)
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack(spacing: 0) {
                    Text("\(selected)")
                        .foregroundStyle(.orange)
                        .bold()
                    if showInsights {
                        Text(" | \(item.sale.quantity)")
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
            }
        }
        
    }
}

#Preview {
    InsightsBillView(item: InterimSale(sale: Sale(id: "",
                                                  name: "Oranges",
                                                  quantity: 3,
                                                  price: 3.0),
                                       unitPrice: 1.0),
                     selected: 2)
}
