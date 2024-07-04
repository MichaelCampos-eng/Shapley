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
    @State var subtotalToString: String = "0.00"
    @State var tax: String = ""
    @State var total: String = "0.00"
    
    
    init(amount: Binding<Double>) {
        self._subtotal = amount
        self._viewModel = StateObject(wrappedValue: SaleSummaryViewModel())
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack{ Text("Subtotal: \(subtotalToString)")
                    .onReceive(Just(subtotal), perform: { newValue in
                        subtotalToString = self.filterToDecimal(String(newValue)) 
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
}

#Preview {
    SaleSummaryView(amount: Binding<Double> (get: {0.00}, set: {_ in }))
}
