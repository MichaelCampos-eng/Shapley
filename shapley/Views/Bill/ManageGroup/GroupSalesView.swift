//
//  UnclaimedItemsView.swift
//  shapley
//
//  Created by Michael Campos on 7/31/24.
//

import SwiftUI

struct GroupSalesView: View {
    
    private let items: [Sale]
    @State private var progress: Double =  0.3
    
    init(items: [Sale]) {
        self.items = items
    }
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.1) { index, item in
                        UnclaimedView(item: item)
                        .padding(.horizontal, 5)
                        .containerRelativeFrame(.horizontal, count: 3, spacing: 0)
                        .scrollTransition(.interactive,
                                          axis: .horizontal) { view, phase in
                            view.offset(y: phase.isIdentity ? 0 : 50)
                                .scaleEffect(phase.isIdentity ? 1 : 0.4)
                                .opacity(phase.isIdentity ? 1 : 0.75)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    GroupSalesView(items: [Sale(id: "1", name: "Bagels", quantity: 9, price: 2.98),
                               Sale(id: "2", name: "Apple", quantity: 27, price: 2.98)])
}
