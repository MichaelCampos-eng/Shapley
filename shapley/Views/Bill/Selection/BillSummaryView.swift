//
//  BillSummaryView.swift
//  shapley
//
//  Created by Michael Campos on 8/12/24.
//
 
import SwiftUI

struct BillSummaryView: View {
    @Environment(\.dismiss ) var dismiss
    @ObservedObject private var viewModel: BillModel
    @Binding private var isPresented: Bool
    
    init(viewModel: BillModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self._isPresented = isPresented
    }
    
    var body: some View {
        if viewModel.isValid() {
            VStack{
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                        .bold()
                        .foregroundStyle(Color.walnutBrown)
                    }
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            isPresented.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .bold()
                            .foregroundStyle(Color.walnutBrown)
                    }
                }
                .padding(.horizontal)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Group Account")
                            .foregroundStyle(Color(.secondaryLabel))
                        Divider()
                        HStack{
                            Text("$\(String(format:"%.2f", viewModel.getTotal()))")
                                .font(.title)
                                .bold()
                            Text( "Total")
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                        HStack {
                            Text("$\(String(format: "%.2f", viewModel.getSubtotal()))")
                                .font(.title3)
                            Text("Subtotal")
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                        HStack{
                            Text("$\(String(format: "%.2f", viewModel.getSalesTax()))")
                                .font(.title3)
                            Text("Tax")
                                .foregroundStyle(Color(.secondaryLabel))
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
                            .foregroundStyle(Color(.secondaryLabel))
                        Divider()
                        HStack {
                            Text("$\(String(format: "%.2f", viewModel.getUserGrandTotal()))")
                                .font(.title)
                                .bold()
                                .foregroundStyle(Color.orange)
                            Text("Total")
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                        HStack {
                            Text( "$\(String(format: "%.2f", viewModel.getUserAmount()))")
                                .font(.title3)
                            Text("Subtotal")
                                .foregroundStyle(Color(.secondaryLabel))
                                .shadow(radius: 10.0)
                        }
                        HStack {
                            Text("$\(String(format: "%.2f", viewModel.getUserTax()))")
                                .font(.title3)
                            Text("Tax")
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.prussianBlue)
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
                                                          activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316")),
    isPresented: Binding(get: {return true}, set: {_ in}))
}
