//
//  SelectSliderView.swift
//  shapley
//
//  Created by Michael Campos on 6/24/24.
//

import SwiftUI

struct SelectSliderView: View {
    
    @Binding var receipt: Bool
    @Binding var gas: Bool
    @Binding var vendue: Bool
    
    var body: some View {
        
        HStack {
            Toggle("Split Bill", systemImage: receipt ? "newspaper.fill" : "newspaper", isOn: Binding(
                get: { receipt },
                set: { newValue in
                    if newValue {
                        receipt = true
                        gas = false
                        vendue = false
                    }
                }
            
            ))
            Toggle("Split Gas", systemImage: gas ? "car.fill" : "car", isOn: Binding(
                get: { gas },
                set: { newValue in
                    if newValue {
                        receipt = false
                        gas = true
                        vendue = false
                    }
                }
            
            ))
            Toggle("Vendue", systemImage: vendue ? "bed.double.fill" : "bed.double", isOn: Binding(
                get: { vendue },
                set: { newValue in
                    if newValue {
                        receipt = false
                        gas = false
                        vendue = true
                    }
                }
            
            ))
        }
        .font(.caption)
        .tint(.prussianBlue)
        .toggleStyle(.button)
        .contentTransition(.symbolEffect)
    }
}

#Preview {
    SelectSliderView(receipt: Binding(get: {true}, set: {_ in }),
                     gas: Binding(get: {false}, set: {_ in }),
                     vendue: Binding(get: {false}, set: {_ in }))
}
