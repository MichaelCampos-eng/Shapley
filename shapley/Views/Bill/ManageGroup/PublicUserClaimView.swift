//
//  PublicUserClaim.swift
//  shapley
//
//  Created by Michael Campos on 7/31/24.
//

import SwiftUI

struct PublicUserClaimView: View {
    @State private var searchText: String = ""
    
    @State private var items: [Sale] = [.init(id: "a", name: "ggg", quantity: 2, price: 1.99),
                                        .init(id: "b", name: "orange", quantity: 1, price: 3.99),
                                        .init(id: "c", name: "bananas", quantity: 4, price: 2.99),
                                        .init(id: "d", name: "melons", quantity: 3, price: 9.99),
                                        .init(id: "e", name: "caac", quantity: 2, price: 1.99),
                                        .init(id: "f", name: "dg", quantity: 1, price: 3.99),
                                        .init(id: "g", name: "banadgnas", quantity: 4, price: 2.99),
                                        .init(id: "h", name: "meldgons", quantity: 3, price: 9.99)]
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.black)
            VStack(alignment: .leading, spacing: 0){
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(0..<32) { i in
                            HStack(spacing: 0) {
                                VStack(alignment: .leading) {
                                    Text("Sarah Palin")
                                        .font(.title2)
                                    Text("$7.56")
                                        .font(.title)
                                        .bold()
                                    Text("$7.45 Subtotal")
                                        .foregroundStyle(Color(.secondaryLabel))
                                    Text("$0.11 Tax")
                                        .foregroundStyle(Color(.secondaryLabel))
                                }
                                Spacer()
                            }
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 20)
                            .scrollTransition(.interactive,
                                              axis: .horizontal) { view, phase in
                                view.opacity(phase.isIdentity ? 1.0 : 0)
                                    .offset(y: phase.isIdentity ? 0 : 50)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.6)
                                    .blur(radius: phase.isIdentity ? 0 : 15)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
            }
            .padding()
        }
        
    }
        
}

#Preview {
    PublicUserClaimView()
}
