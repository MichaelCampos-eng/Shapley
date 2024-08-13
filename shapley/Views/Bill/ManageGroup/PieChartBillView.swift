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
            Chart(items, id: \.itemName) { item in
                SectorMark(angle: .value("Macros", item.quantityClaimed * multiplier),
                           innerRadius: .ratio(0.65),
                           outerRadius: selectedItem?.itemName == item.itemName ? .ratio(1.5) : .ratio(0.9),
                           angularInset: 1.5)
                .foregroundStyle(by: .value("Name", item.itemName ))
                .cornerRadius(10)
            }
            .chartAngleSelection(value: $selectedCount)
            .chartLegend(.hidden)
            .chartBackground { geometry in
                VStack {
                    if let selectedItem {
                        Text(selectedItem.itemName)
                            .font(.title3)
                            .foregroundStyle(Color(.secondaryLabel))
                            .bold()
                        Text("(\(selectedItem.quantityClaimed))")
                            .font(.title3)
                            .foregroundStyle(Color.white)
                            .bold()
                        Text("$\(String(format: "%.2f", Double(selectedItem.quantityClaimed) * selectedItem.unitPrice))")
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
    PieChartBillView(items: [Claim(itemName: "Water", quantityClaimed: 12, unitPrice: 3.99),
                             Claim(itemName: "Oranges", quantityClaimed: 3, unitPrice: 1.99),
                             Claim(itemName: "Apples", quantityClaimed: 8, unitPrice: 9.99)])
}
