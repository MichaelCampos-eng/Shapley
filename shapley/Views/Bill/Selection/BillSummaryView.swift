//
//  BillSummaryView.swift
//  shapley
//
//  Created by Michael Campos on 8/12/24.
//
 
import SwiftUI

struct BillSummaryView: View {
    @Environment(\.dismiss ) var dismiss
    @EnvironmentObject private var viewModel: BillModel
    @Binding private var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
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
                            Text("$\(String(format:"%.2f", viewModel.receipt!.summary.total))")
                                .font(.title)
                                .bold()
                            Text( "Total")
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                        HStack {
                            Text("$\(String(format: "%.2f", viewModel.receipt!.summary.subtotal))")
                                .font(.title3)
                            Text("Subtotal")
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                        HStack{
                            Text("$\(String(format: "%.2f", viewModel.receipt!.summary.tax))")
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
                            Text("$\(String(format: "%.2f", viewModel.userInvoice!.debt))")
                                .font(.title)
                                .bold()
                                .foregroundStyle(Color.orange)
                            Text("Total")
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                        HStack {
                            Text( "$\(String(format: "%.2f", viewModel.userInvoice!.subtotal))")
                                .font(.title3)
                            Text("Subtotal")
                                .foregroundStyle(Color(.secondaryLabel))
                                .shadow(radius: 10.0)
                        }
                        HStack {
                            Text("$\(String(format: "%.2f", viewModel.userInvoice!.tax))")
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
    BillSummaryView(isPresented: Binding(get: {return true}, set: {_ in}))
}
