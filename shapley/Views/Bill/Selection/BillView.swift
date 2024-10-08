//
//  SplitBillView.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import SwiftUI

struct BillView: View {
    @StateObject var viewModel: BillViewModel
    @State private var isShifted: Bool = false
    @State private var isGroupPresented: Bool = false
    
    init(meta: ModelPaths) {
        self._viewModel = StateObject(wrappedValue: BillViewModel(meta: meta))
    }
         
    var body: some View {
        ZStack{
            Color.khaki
                .ignoresSafeArea()
            if viewModel.isValid() {
                 VStack {
                    BillHeaderView()
                    BillSummaryView(isPresented: $isGroupPresented)
                        .padding(.horizontal)
                    BillScrollView()
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                 .environmentObject(viewModel)
                 .sheet(isPresented: $isGroupPresented) {
                     ManageBillGroupView(meta: viewModel.getMeta())
                         .ignoresSafeArea()
                         .background {
                             Color.brown
                                 .ignoresSafeArea()
                         }
                 }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    BillView(meta: ModelPaths(modelId: "TxweNwsv2dnTevIpGcOb",
                            userId: "rXsJ8ZNOodV9acUZbxLpC8WAqry2",
                            activityId: "FFFD01B2-5F57-41AA-A4BF-41350382674C"))
}
