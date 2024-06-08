//
//  HeaderView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import SwiftUI

struct HeaderView: View {
    
    let title: String
    let subtitle: String
    let angle: Double
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundColor(Color.orange)
                .rotationEffect(Angle(degrees: angle))
                .frame(width: UIScreen.main.bounds.width * 3)
                .offset(y: 40)
            
            Rectangle()
                .foregroundColor(Color.yellow)
                .rotationEffect(Angle(degrees: angle))
                .frame(width: UIScreen.main.bounds.width * 3)
                .offset(y:0)
            
            Capsule()
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: angle))
                .frame(width: UIScreen.main.bounds.width * 3, height: 10)
                .offset(y:135)
            
            Rectangle()
                .foregroundColor(Color.orange)
                .rotationEffect(Angle(degrees: angle))
                .frame(width: UIScreen.main.bounds.width * 3)
                .offset(y: -40)
//            Rectangle()
//                .foregroundColor(Color.orange)
//                .rotationEffect(Angle(degrees: angle))
//                .frame(width: UIScreen.main.bounds.width * 3)
//                .offset(y: -80)
            
            VStack {
                Text(title)
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .bold()
                Text(subtitle)
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
            }
        }
        .frame(height: 300)
        Spacer()
    }
}

#Preview {
    HeaderView(title: "Title",
                subtitle: "Subtitle",
               angle: 15)
}
