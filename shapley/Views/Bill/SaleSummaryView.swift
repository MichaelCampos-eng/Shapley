//
//  SaleSummaryView.swift
//  shapley
//
//  Created by Michael Campos on 6/26/24.
//

import SwiftUI
import Combine

struct SaleSummaryView: View {
    @State var subtotal: String = ""
    @State var total: String = ""
    @State var tax: String = ""
    @ObservedObject var viewModel: SplitBillSetupModel
    
    init(model: SplitBillSetupModel) {
        self.viewModel = model
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack{ Text("Subtotal: \(subtotal)")
                    .onReceive(viewModel.$receipt, perform: { newValue in
                        subtotal = String(format: "%.2f", newValue.subtotal)
                    })
            }
            HStack{
                Spacer()
                Text("Sales Tax:")
                TextField("0.00", text: $tax)
                    .multilineTextAlignment(.trailing)
                    .fixedSize(horizontal: true, vertical: false)
                    .keyboardType(.numberPad)
                    .onReceive(Just(tax), perform: { newValue in
                        tax = self.formatMoney(newValue)
                        tax = self.limitText(tax, 10)
                        var newReceipt = self.viewModel.receipt
                        newReceipt.changeTax(Double(tax) ?? 0.0)
                        if viewModel.isValidReceipt(newReceipt) {
                            viewModel.submitReceipt(newReceipt)
                        }
                    })
            }
            HStack{Text("Total: \( String(format: "%.2f", viewModel.receipt.total))")}
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
    SaleSummaryView(model: SplitBillSetupModel(id: ""))
}
