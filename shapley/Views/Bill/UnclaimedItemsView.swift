//
//  UnclaimedItemsView.swift
//  shapley
//
//  Created by Michael Campos on 7/31/24.
//

import SwiftUI

struct UnclaimedItemsView: View {
    
    private let items: [String]
    @State private var progress: Double =  0.3
    
    init(items: [String]) {
        self.items = items
    }
    
    var body: some View {
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 20.0)
                .fill(Color.black)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(items, id:\.self) { item in
                        GeometryReader { metrics in
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("Item Name")
                                    .font(.title2)
                                    .foregroundStyle(Color(.secondaryLabel))
                                Text("12 left")
                                    .font(.title)
                                    .bold()
                                // Progress bar
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .frame(height: 10)
                                        .foregroundStyle(Color.gray.opacity(0.5))
                                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                        .frame(width: metrics.size.width * progress, height: 10)
                                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]),
                                                                        startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/,
                                                                        endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 16)
                        .scrollTransition(.interactive,
                                          axis: .horizontal) { view, phase in
                            view.opacity(phase.isIdentity ? 1.0 : 0)
                                .offset(y: phase.isIdentity ? 0 : 50)
                                .scaleEffect(phase.isIdentity ? 1 : 0.2)
                                .blur(radius: phase.isIdentity ? 0 : 15)
                                .rotationEffect(.degrees(phase.value > 0 ? -30 : 0))
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    UnclaimedItemsView(items: ["ad", "sdf", "dg", "dsg", "reh", "hredhre"])
}
