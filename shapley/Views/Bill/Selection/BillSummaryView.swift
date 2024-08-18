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
        if viewModel.isValid() {
            VStack{
                HStack {
                    Text("Selection")
                        .bold()
                    Spacer()
                    Button {
//                        isGroupPresented.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Group Account")
                            .foregroundStyle(Color.paleDogwood)
                        Divider()
                        HStack{
                            Text("$\(String(format:"%.2f", viewModel.getTotal()))")
                                .font(.title)
                                .bold()
                            Text( "Total")
                                .foregroundStyle(Color.paleDogwood)
                        }
                        HStack {
                            Text("$\(String(format: "%.2f", viewModel.getSubtotal()))")
                                .font(.title3)
                            Text("Subtotal")
                                .foregroundStyle(Color.paleDogwood)
                        }
                        HStack{
                            Text("$\(String(format: "%.2f", viewModel.getSalesTax()))")
                                .font(.title3)
                            Text("Tax")
                                .foregroundStyle(Color.paleDogwood)
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.roseTaupe)
                            .shadow(radius: 10.0)
                    }
                    VStack(alignment: .leading) {
                        Text("Your Account")
                            .foregroundStyle(Color.paleDogwood)
                        Divider()
                        HStack {
                            Text("$\(String(format: "%.2f", viewModel.getUserGrandTotal()))")
                                .font(.title)
                                .bold()
                                .foregroundStyle(Color.orange)
                            Text("Total")
                                .foregroundStyle(Color.paleDogwood)
                        }
                        HStack {
                            Text( "$\(String(format: "%.2f", viewModel.getUserAmount()))")
                                .font(.title3)
                            Text("Subtotal")
                                .foregroundStyle(Color.paleDogwood)
                                .shadow(radius: 10.0)
                        }
                        HStack {
                            Text("$\(String(format: "%.2f", viewModel.getUserTax()))")
                                .font(.title3)
                            Text("Tax")
                                .foregroundStyle(Color.paleDogwood)
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.prussianBlue.opacity(0.8))
                            .shadow(radius: 10.0)
                    }
                }
            }
        }
    }
}

#Preview {
    BillSummaryView(viewModel: BillModel(meta: ModelPaths(id: "DkUXKLdl3wDRyl5iPdrs",
                                                          userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                                                          activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316")))
}
