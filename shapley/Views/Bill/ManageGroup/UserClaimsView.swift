//
//  TestingRect.swift
//  shapley
//
//  Created by Michael Campos on 8/4/24.
//

import SwiftUI

struct UserClaimsView: View {
    
    @StateObject private var viewModel: ManageBillUserModel
    
    init(receipt: Receipt, refPaths: ModelPaths) {
        self._viewModel = StateObject(wrappedValue: ManageBillUserModel(receipt: receipt, refPaths: refPaths))
    }
    
    var body: some View {
        let color: [Color] = [.black, .prussianBlue, .violet]
    
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundColor(color.randomElement())
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            if viewModel.isAvailable() {
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.getAlias())
                            .foregroundStyle(Color.paleDogwood)
                            .font(.title2)
                        Text("$\(String(format: "%.2f", viewModel.getDebt()))")
                            .font(.title)
                            .bold()
                        Text("$\(String(format: "%.2f", viewModel.getSubtotal())) Subtotal")
                            .foregroundStyle(Color(.secondaryLabel))
                        Text("$\(String(format: "%.2f", viewModel.getTax())) Tax")
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                    .shadow(radius: 10)
                    PieChartBillView(items: viewModel.getItems())
                }
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
                   refPaths: ModelPaths(id: "cG1pKA6E7gCXkysxTD3o",
                                      userId: "10b8fa78neXKKsaGdiZvbnzDCN62",
                                      activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316"))
}
