//
//  DebtView.swift
//  shapley
//
//  Created by Michael Campos on 8/1/24.
//

import SwiftUI

struct DebtView: View {
    
    @State var progress: Double = 0.3
    
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color.black)
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Missing")
                        .font(.title2)
                        .foregroundStyle(Color(.secondaryLabel))
                    
                    Text("$12.90")
                        .bold()
                        .font(.title)
                        .foregroundStyle(Color.white)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .frame(height: 10)
                            .foregroundStyle(Color.gray.opacity(0.5))
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .frame(width: metrics.size.width * progress, height: 10)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            
        }
    }
}

#Preview {
    DebtView()
}
