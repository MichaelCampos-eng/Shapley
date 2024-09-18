//
//  InsightsBillView.swift
//  shapley
//
//  Created by Michael Campos on 8/16/24.
//

import SwiftUI

struct InsightsBillView: View {
    
    @State var showInsights: Bool = false
    private let item: Sale
    private let selected: Int
    
    init(item: Sale, selected: Int) {
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
                Text("\(item.name)")
                if !showInsights {
                    Text("$\(String(format: "%.2f", Double(selected) * item.unitPrice))")
                        .font(.footnote)
                        .bold()
                }
                if showInsights {
                    HStack(alignment: .center) {
                        Text("$\(String(format: "%.2f", item.price)) Total")
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
                        Text(" | \(item.quantity)")
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
            }
        }
        
    }
}

#Preview {
    InsightsBillView(item: Sale(id: "", 
                                name: "apple",
                                quantity: 2,
                                price: 1.98),
                     selected: 2)
}
