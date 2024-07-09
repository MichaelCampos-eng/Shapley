//
//  SaleView.swift
//  shapley
//
//  Created by Michael Campos on 6/25/24.
//

import SwiftUI
import Combine

struct SaleView: View {
    @ObservedObject var viewModel: SplitBillSetupModel
    @State private var name: String = ""
    @State private var quantity: String = ""
    @State private var price: String = ""
    
    private let saleId: String
    
    init(entry: Sale, givenModel: SplitBillSetupModel) {
        print("Instatiating view")
        self.viewModel = givenModel
        self.saleId = entry.id
    }

    var body: some View {
                HStack {
                    TextField("Item Name", text: $name)
                    .onReceive(Just(name), perform: { _ in
                        name = self.limitText(name, 15)
                        let newSale = Sale(id: self.saleId, name: name, quantity: Int(quantity) ?? 0, price: Double(price) ?? 0.0)
                        if viewModel.isValidEntry(newSale) {
                            print("Sale View: \(newSale)")
                            viewModel.submitEntry(newSale)
                            
                        }
                    })
                    TextField("Quantity", text: $quantity)
                        .keyboardType(.numberPad)
                        .onReceive(Just(quantity), perform: { _ in
                            let newSale = Sale(id: self.saleId, name: name, quantity: Int(quantity) ?? 0, price: Double(price) ?? 0.0)
                            if viewModel.isValidEntry(newSale) {
                                print("Sale View: \(newSale)")
                                viewModel.submitEntry(newSale)
                            }
                        })
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .onReceive(Just(price), perform: { _ in
                            price = self.formatMoney(price)
                            price = self.limitText(price, 8)
                            let newSale = Sale(id: self.saleId, name: name, quantity: Int(quantity) ?? 0, price: Double(price) ?? 0.0)
                            if viewModel.isValidEntry(newSale) {
                                print("Sale View: \(newSale)")
                                viewModel.submitEntry(newSale)
                            }
                        })
                }
                .swipeActions {
                    Button {
                        viewModel.deleteEntry(saleId: self.saleId)
                    } label: {
                        Label("Delete", systemImage: "minus")
                    }
                    .tint(.red)
                }
        }
    
    private func formatMoney(_ value: String) -> String {
            if value == "" {
                return value
            }
            var filtered = value.filter { "0123456789".contains($0) }
            while filtered.hasPrefix("0") {
                filtered.removeFirst()
            }
            
            let num = filtered.count
            let nec = 3 - num
            if nec > 0 {
                filtered = String(repeating: "0", count: nec) + filtered
            }
            let index = filtered.index(filtered.endIndex, offsetBy: -2)
            filtered.insert(".", at: index)
            return filtered
        }
    
    private func limitText(_ value: String, _ upper: Int) -> String {
        var filtered = value
        if filtered.count > upper {
            filtered = String(filtered.prefix(upper))
        }
        return filtered
    }
}

#Preview {
    SaleView(entry: Sale(id: "",
                         name: "",
                         quantity: 0,
                         price: 0.0),
             givenModel: SplitBillSetupModel(id: ""))
}
