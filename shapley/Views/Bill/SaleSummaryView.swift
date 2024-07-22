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
                Image(systemName: "pencil")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Text("Sales Tax:")
                TextField("0.00", text: $tax)
                    .multilineTextAlignment(.trailing)
                    .fixedSize(horizontal: true, vertical: false)
                    .keyboardType(.numberPad)
                    .onReceive(Just(tax), perform: { newValue in
                        tax = TextUtil.formatDecimal(newValue)
                        tax = TextUtil.limitText(tax, 10)
                        var newReceipt = self.viewModel.receipt
                        newReceipt.changeTax(Double(tax) ?? 0.0)
                        if viewModel.isValidReceipt(newReceipt) {
                            viewModel.updateReceipt(receipt: newReceipt)
                        }
                    })
                    .foregroundColor(.white)
            }
            HStack{Text("Total: \(String(format: "%.2f", viewModel.receipt.total))")}
        }
        .font(.headline)
        .foregroundColor(.gray)
    }
}

#Preview {
    SaleSummaryView(model: SplitBillSetupModel(id: ""))
}
