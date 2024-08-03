//
//  BillGroupUserVIew.swift
//  shapley
//
//  Created by Michael Campos on 7/29/24.
//

import SwiftUI

struct BillGroupUserView: View {
    
//    @StateObject var viewModel: ManageBillUserModel
    
    init(meta: BillGroup) {
//        self._viewModel = StateObject(wrappedValue: ManageBillUserModel(meta: meta))
    }
    
    var body: some View {
        
        
        Color.orange
            .ignoresSafeArea()
            .overlay {
                VStack{
                    PieChartBillView()
                    Spacer()
                    HStack {
                        Text("Anvil Fent")
                            .bold()
                            .font(.largeTitle)
                            .padding()
                        Spacer()
                    }
                    
                    
                    HStack {
                        DebtView()
                        UnclaimedItemsView(items: ["a", "b", "c", "d", "e", "f", "g"])
                    }
                    .frame(maxHeight: 120)
                    Spacer()
                    PublicUserClaimView()
                }
                .padding(.horizontal)
                .background(.ultraThinMaterial)
            }
            
    }
}

#Preview {
    BillGroupUserView(meta: BillGroup(metaExpense: MetaExpense(id: "",
                                                               userId: "",
                                                               activityId: "",
                                                               type: .Vendue,
                                                               dateCreated: TimeInterval()),
                                      validUserId: ""))
}
