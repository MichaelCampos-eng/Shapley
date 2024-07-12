//
//  SwiftUIView.swift
//  shapley
//
//  Created by Michael Campos on 7/10/24.
//

import SwiftUI

struct SliderActivityView: View {
    
    @Binding var createActivity: Bool
    @Binding var joinActivity: Bool
    
    var body: some View {
        HStack {
            Toggle("Create Activity", systemImage: createActivity ? "figure.run.circle.fill" : "figure.run.circle", isOn: Binding(
                get: { createActivity },
                set: { newValue in
                    if newValue {
                        createActivity = true
                        joinActivity = false
                    }
                }
            ))
            .font(.caption)
            .tint(.orange)
            .toggleStyle(.button)
            .contentTransition(.symbolEffect)
            
            Toggle("Join Group", systemImage: joinActivity ? "person.3.fill" : "person.3", isOn: Binding(
                get: { joinActivity },
                set: { newValue in
                    if newValue {
                        createActivity = false
                        joinActivity = true
                    }
                }
            ))
            .font(.caption)
            .tint(.orange)
            .toggleStyle(.button)
            .contentTransition(.symbolEffect)
        }
    }
}

#Preview {
    SliderActivityView(createActivity: Binding(get: {true}, set: {_ in}),
                       joinActivity: Binding(get: {false}, set: {_ in}))
}
