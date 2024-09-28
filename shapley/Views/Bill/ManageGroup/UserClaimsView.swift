//
//  TestingRect.swift
//  shapley
//
//  Created by Michael Campos on 8/4/24.
//

import SwiftUI

struct UserClaimsView: View {
    @StateObject private var viewModel: ManageBillUserModel
    
    init(receipt: Receipt, refs: UserDisplayRefs) {
        self._viewModel = StateObject(wrappedValue: ManageBillUserModel(receipt: receipt, refs: refs))
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(viewModel.getColor())
                .shadow(radius: 10)
            if viewModel.isAvailable() {
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.alias!)
                            .foregroundStyle(Color.white)
                            .font(.title2)
                        Text("$\(String(format: "%.2f", viewModel.invoice!.debt))")
                            .font(.title)
                            .bold()
                        Text("$\(String(format: "%.2f", viewModel.invoice!.subtotal)) Subtotal")
                            .foregroundStyle(Color(.secondaryLabel))
                        Text("$\(String(format: "%.2f", viewModel.invoice!.tax)) Tax")
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                    .shadow(radius: 10)
                    PieChartBillView(items: viewModel.invoice!.claims)
                }
                .animation(.spring(Spring(duration: 0.5, bounce: 0.3), blendDuration: 0.1),
                           value: viewModel.invoice!.claims)
                .padding(.leading)
                .transition(AnyTransition.asymmetric(insertion: .scale, removal: .scale))
            }
        }
        
    }
}

#Preview {
    UserClaimsView(receipt: Receipt(summary: GeneralReceipt(subtotal: 12.95,
                                                            tax: 5.55),
                                    items: [Sale(id: "B1072282-F180-4375-BB09-BF2E3DD5386D",
                                                 name: "Chips",
                                                 quantity: 2,
                                                 price: 3.98),
                                            Sale(id: "2B50EF5E-23F8-4DFB-B914-A653BE9C5B0B",
                                                 name: "Snapples",
                                                 quantity: 3,
                                                 price: 8.97)]),
                   refs: UserDisplayRefs(paths: ModelPaths(modelId: "cG1pKA6E7gCXkysxTD3o",
                                                         userId: "10b8fa78neXKKsaGdiZvbnzDCN62",
                                                         activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316")))
}
