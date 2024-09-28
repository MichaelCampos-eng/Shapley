//
//  SaleSummaryView.swift
//  shapley
//
//  Created by Michael Campos on 6/26/24.
//

import SwiftUI
import Combine

struct SaleSummaryView: View {
    @EnvironmentObject var viewModel: SplitBillSetupModel
    @State private var subtotal: String = ""
    @State private var total: String = ""
    @State private var tax: String = ""
    @FocusState private var focused: Field?
    
    init(focused: FocusState<Field?>) {
        self._focused = focused
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Total Amount")
                .font(.caption)
                .foregroundStyle(Color(.secondaryLabel))
            Text("$\(String(format: "%.2f", viewModel.receipt.total))")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color.white)
            HStack {
                Image(systemName: "plus")
                    .font(.caption)
                    .foregroundStyle(Color.white)
                Text("\(subtotal)")
                    .bold()
                    .foregroundStyle(Color.white)
                    .onReceive(viewModel.$receipt, perform: { newValue in
                        subtotal = String(format: "%.2f", newValue.subtotal)
                    })
                Text("Subtotal")
                    .foregroundStyle(Color(.secondaryLabel))
                    .font(.caption)
            }
            HStack {
                Image(systemName: "plus")
                    .font(.caption)
                    .foregroundStyle(Color.white)
                TextField("0.00", text: $tax)
                    .focused($focused, equals: Field.summary)
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
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button(action: { focused = nil }, label: {
                                Text("Done")
                                    .foregroundStyle(Color.white)
                                    .bold()
                            })
                        }
                    }
                Text("Tax")
                    .foregroundStyle(Color(.secondaryLabel))
                    .font(.caption)
                Image(systemName: "pencil")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

#Preview {
    SaleSummaryView(focused: FocusState())
}
