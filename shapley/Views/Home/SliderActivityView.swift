//
//  SwiftUIView.swift
//  shapley
//
//  Created by Michael Campos on 7/10/24.
//

import SwiftUI

struct SliderActivityView: View {
    
    @Binding var option1: Bool
    @State private var option2: Bool = false

    
    var body: some View {
        HStack {
            Toggle("Create", systemImage: option1 ? "figure.run.circle.fill" : "figure.run.circle", isOn: Binding(
                get: { option1 },
                set: { newValue in
                    if newValue {
                        option1 = true
                        option2 = false
                    }
                }
            ))
            .tint(.prussianBlue)
            .toggleStyle(.button)
            .contentTransition(.symbolEffect)
            
            Toggle("Join", systemImage: option2 ? "person.3.fill" : "person.3", isOn: Binding(
                get: { option2 },
                set: { newValue in
                    if newValue {
                        option2 = true
                        option1 = false
                    }
                }
            ))
            .tint(.prussianBlue)
            .toggleStyle(.button)
            .contentTransition(.symbolEffect)
        }
    }
}

#Preview {
    SliderActivityView(option1: Binding(get: {true}, set: {_ in}))
}
