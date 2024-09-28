//
//  PieChartBill.swift
//  shapley
//
//  Created by Michael Campos on 7/31/24.
//

import SwiftUI
import Charts

struct PieChartBillView: View {
    @State private var selectedCount: Int?
    @State private var selectedItem: Claim?

    private let multiplier = 100
    private var items: [Claim]
    
    init(items: [Claim]) {
        self.items = items
    }
    
    var body: some View {
        VStack {
            Chart(items, id: \.sale.id) { item in
                SectorMark(angle: .value("Macros", item.quantityClaimed * multiplier),
                           innerRadius: .ratio(0.65),
                           outerRadius: selectedItem?.sale.name == item.sale.name ? .ratio(1.5) : .ratio(0.9),
                           angularInset: 1.5)
                .foregroundStyle(by: .value("id", item.sale.id))
                .cornerRadius(10)
            }
            .chartAngleSelection(value: $selectedCount)
            .chartLegend(.hidden)
            .chartBackground { geometry in
                VStack {
                    if items.isEmpty {
                        Image(systemName: "cart.circle")
                            .font(.title)
                            .foregroundStyle(Color.white)
                            .bold()
                        Text("Empty cart")
                    }
                    else if let selectedItem {
                        Text("\(selectedItem.quantityClaimed)")
                            .font(.title3)
                            .foregroundStyle(Color.white)
                            .bold()
                        Text(selectedItem.sale.name)
                            .font(.title3)
                            .foregroundStyle(Color(.secondaryLabel))
                            .bold()
                        Text("$\(String(format: "%.2f", Double(selectedItem.quantityClaimed) * selectedItem.sale.unitPrice))")
                            .font(.title3)
                            .foregroundStyle(Color(.secondaryLabel))
                            .bold()
                    } else {
                        Image(systemName: "takeoutbag.and.cup.and.straw")
                            .font(.title)
                            .foregroundStyle(Color.white)
                            .bold()
                        Text("Tap to select")
                    }
                }
                .position(x: geometry.plotSize.width / 2, y: geometry.plotSize.height / 2)
                .onTapGesture {
                    selectedItem = nil
                }
            }
        }
        .animation(.bouncy, value: selectedItem)
        .padding()
        .shadow(radius: 10)
        .onChange(of: selectedCount) { oldValue, newValue in
            if let newValue {
                withAnimation {
                    selectedItem = getSelectedItem(value: newValue)
                }
            }
        }
    }
    
    private func getSelectedItem(value: Int) -> Claim {
        var cumulativeTotal = 0
        return items.first { itemType in
            cumulativeTotal += itemType.quantityClaimed * multiplier
            if value <= cumulativeTotal {
                return true
            }
            return false
        }!
    }
}

#Preview {
    
    PieChartBillView(items: [Claim(sale: Sale(id: "a", 
                                              name: "Water",
                                              quantity: 12,
                                              price: 23.88), 
                                   quantityClaimed: 4),
                             Claim(sale: Sale(id: "b",
                                              name: "Oranges",
                                              quantity: 3,
                                              price: 8.97), 
                                   quantityClaimed: 1),
                             Claim(sale: Sale(id: "c", 
                                              name: "Apples",
                                              quantity: 5,
                                              price: 19.55),
                                   quantityClaimed: 4)])
}
