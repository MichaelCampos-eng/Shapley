//
//  ButtonView.swift
//  shapley
//
//  Created by Michael Campos on 5/23/24.
//

import SwiftUI

struct ButtonView: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
        .padding()
    }
}

#Preview {
    ButtonView(title: "Example", 
               background: Color.blue) {
        // Action
    }
}
