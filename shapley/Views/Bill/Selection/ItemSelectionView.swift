//
//  ItemSelectionView.swift
//  shapley
//
//  Created by Michael Campos on 8/12/24.
//

import SwiftUI

struct ItemSelectionView: View {
    @ObservedObject var viewModel: BillModel
    @State private var isShifted: Bool = false
    
    init(viewModel: BillModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView{
            LazyVStack {
                ForEach(Array(viewModel.getSales().enumerated()), id: \.element.id) { index, item in
                    if index == 0 {
                        ZStack {
                            Label("Demonstration", systemImage: "arrow.left.arrow.right")
                                .labelStyle(.iconOnly)
                                .font(.title2)
                                .padding(.trailing)
                                .foregroundStyle(Color.orange)
                                .offset(x:-205)
                            
                            ItemBillView(sale: item,
                                         user: viewModel.userModel!,
                                         updateAction: viewModel.setItem(itemId:quantity:))
                            
                        }
                        .offset(x: isShifted ? 40 : 0)
                        .animation(.bouncy(duration: 1.0), value: isShifted)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isShifted = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    isShifted = false
                                }
                            }
                        }
                    } else {
                        ItemBillView(sale: item,
                                     user: viewModel.userModel!,
                                     updateAction: viewModel.setItem(itemId:quantity:))
                    }
                }
            }
        }
    }
}

#Preview {
    ItemSelectionView(viewModel: BillModel(meta: ModelPaths(id: "DkUXKLdl3wDRyl5iPdrs",
                                                            userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                                                            activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316")))
}
