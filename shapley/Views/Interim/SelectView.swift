//
//  ButtonView.swift
//  shapley
//
//  Created by Michael Campos on 5/23/24.
//

import SwiftUI

struct SelectView: View {
    let title: String
    let background: Color
    let angle: Double
    let width: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .rotationEffect(Angle(degrees: angle))
                .foregroundColor(background)
                .edgesIgnoringSafeArea(.all)
                .frame(width: width)

            Text(title)
                .foregroundColor(Color.white)
                .font(.system(size: 24, weight: .bold))
        }
    }
}

#Preview {
    SelectView(title: "Example",
               background: Color.blue,
               angle: 10,
               width: 1000)
}
