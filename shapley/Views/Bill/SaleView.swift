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
        self.viewModel = givenModel
        self.saleId = entry.id
    }

    var body: some View {
                HStack {
                    TextField("Item Name", text: $name)
                    .onReceive(Just(name), perform: { _ in
                        name = TextUtil.limitText(name, 15)
                        let newSale = Sale(id: self.saleId, name: name, quantity: Int(quantity) ?? 0, price: Double(price) ?? 0.0)
                        if viewModel.isValidEntry(newSale) {
                            viewModel.updateEntry(sale: newSale)
                        }
                    })
                    .foregroundColor(.white)
                    TextField("Quantity", text: $quantity)
                        .keyboardType(.numberPad)
                        .onReceive(Just(quantity), perform: { _ in
                            let newSale = Sale(id: self.saleId, name: name, quantity: Int(quantity) ?? 0, price: Double(price) ?? 0.0)
                            if viewModel.isValidEntry(newSale) {
                                viewModel.updateEntry(sale: newSale)
                            }
                        })
                        .foregroundColor(.white)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .onReceive(Just(price), perform: { _ in
                            price = TextUtil.formatDecimal(price)
                            price = TextUtil.limitText(price, 8)
                            let newSale = Sale(id: self.saleId, name: name, quantity: Int(quantity) ?? 0, price: Double(price) ?? 0.0)
                            if viewModel.isValidEntry(newSale) {
                                viewModel.updateEntry(sale: newSale)
                            }
                        })
                        .foregroundColor(.white)
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
}

#Preview {
    SaleView(entry: Sale(id: "",
                         name: "",
                         quantity: 0,
                         price: 0.0),
             givenModel: SplitBillSetupModel(id: ""))
}
