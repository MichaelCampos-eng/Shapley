//
//  SaleSummaryView.swift
//  shapley
//
//  Created by Michael Campos on 6/26/24.
//

import SwiftUI
import Combine

struct SaleSummaryView: View {
    
    @StateObject var viewModel: SaleSummaryViewModel
    
    @Binding var subtotal: Double
    @State var tax: String = ""
    @State var total: String = "0.00"
    
    
    init(amount: Binding<Double>) {
        self._subtotal = amount
        self._viewModel = StateObject(wrappedValue: SaleSummaryViewModel())
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack{ Text("Subtotal: \(subtotal)")
                    .onReceive(Just(subtotal), perform: { newValue in
                        subtotal = atof(self.filterToDecimal(String(newValue)))
                        print(subtotal)
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
                        tax = self.filterToDecimal(tax)
                    })
            }
            HStack{Text("Total: \(total)")}
        }
    }
    
    private func filterToDecimal(_ value: String) -> String {
     
            var filtered = value.filter { "0123456789".contains($0) }
            filtered = filtered.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
            if filtered.count > 5 {
                filtered = String(filtered.prefix(5))
            }
            if filtered.count >= 3 {
                let index = filtered.index(filtered.endIndex, offsetBy: -2)
                filtered.insert(".", at: index)
            } else if filtered.count == 2 {
                filtered = String(repeating: "0", count: 1) + "." +  filtered
            } else if filtered.count == 1 {
                filtered = String(repeating: "0", count: 2) + "." +  filtered
            }
            return filtered
        }
}

#Preview {
    SaleSummaryView(amount: Binding<Double> (get: {0.0}, set: {_ in }))
}
