//
//  SplitBillView.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import SwiftUI

struct BillView: View {
    @StateObject var viewModel: BillModel
    @State private var isShifted: Bool = false
    @State private var isGroupPresented: Bool = false
    
    init(meta: MetaExpense) {
        self._viewModel = StateObject(wrappedValue: BillModel(meta: meta))
    }
    
         
    var body: some View {
        VStack {
            if viewModel.isValid() {
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
                .navigationTitle(viewModel.getTitle())
            }
        }
        .navigationTitle("Receipt")
        .toolbar {
            Button {
                isGroupPresented.toggle()
            } label: {
                Image(systemName: "person.3")
                    .foregroundColor(.orange)
            }
            Button {
                print("temp")
            } label: {
                Image(systemName: "pencil")
                    .foregroundColor(.orange)
            }
            
        }
//        .sheet(isPresented: $isGroupPresented, content: {
//            ManageBillGroupView(meta: viewModel.getMeta())
////                .presentationContentInteraction(.scrolls)
//        })
        
        if isGroupPresented {
            ManageBillGroupView(meta: viewModel.getMeta())
        }
        
        // TODO: Incorporate manage group view and add animations
        
    }
}

struct Demonstration: View {
    var width: CGFloat
    let symbol: String
    
    init(width: CGFloat, symbol: String) {
        self.width = width
        self.symbol = symbol
    }
    
    var body: some View {
        Color.clear
            .overlay(alignment: .trailing) {
                Label("Demonstration", systemImage: symbol)
                    .labelStyle(.iconOnly)
                    .padding(.trailing)
            }
            .clipped()
            .frame(width: width)
            .font(.title2)
    }
}

#Preview {
    BillView(meta: MetaExpense(id: "DkUXKLdl3wDRyl5iPdrs",
                            userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                            activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316",
                            type: .Vendue,
                            dateCreated: TimeInterval()))
}
