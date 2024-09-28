//
//  BillScrollView.swift
//  shapley
//
//  Created by Michael Campos on 9/17/24.
//

import SwiftUI

struct BillScrollView: View {
    @EnvironmentObject private var viewModel: BillViewModel
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: true){
                LazyVStack(spacing: 0) {
                    ForEach(Array(viewModel.receipt!.items.enumerated()), id: \.element.id) { index, item in
                        ItemBillView(claim: viewModel.userInvoice!.claims.first(where: {$0.sale.id == item.id}) ?? Claim(sale: item, quantityClaimed: 0),
                                     updateAction: viewModel.setItem(itemId:quantity:),
                                     isFirst: index == 0)
                        .scrollTransition(.interactive,
                                          axis: .vertical) { view, phase in
                            view.scaleEffect(phase.isIdentity ? 1.0 : 0)
                                .opacity(phase.isIdentity ? 1.0 : 0)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
        .mask {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.black)
        }
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.gunMetal)
                .shadow(radius: 15.0)
        }
    }
}

#Preview {
    BillScrollView()
}
