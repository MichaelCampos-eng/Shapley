//
//  BillSummaryView.swift
//  shapley
//
//  Created by Michael Campos on 8/12/24.
//

import SwiftUI

struct BillSummaryView: View {
    @ObservedObject var viewModel: BillModel
    
    init(viewModel: BillModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack{
            Spacer()
            if viewModel.isOwner() {
                VStack(alignment: .trailing) {
                    HStack{
                        Text( "Total: \(String(format:"%.2f", viewModel.getTotal() ))")
                    }
                    HStack {
                        Text( "Your Subtotal: \(String(format: "%.2f", viewModel.getUserAmount()))" )
                    }
                    HStack {
                        Text("Your Tax: \(String(format: "%.2f", viewModel.getUserTax()))")
                    }
                    HStack {
                        Text("Your Total:  \(String(format: "%.2f", viewModel.getUserGrandTotal()))")
                            .foregroundStyle(.orange)
                    }
                    HStack {
                        Text( "Missing: \(String(format: "%.2f", viewModel.getTotal() - viewModel.getUserGrandTotal()))")
                            .foregroundStyle(.red)
                    }
                }
            } else {
                Text("Subject POV")
            }
        }
    }
}

#Preview {
    BillSummaryView(viewModel: BillModel(meta: ModelPaths(id: "",
                                                           userId: "",
                                                           activityId: "")))
}
