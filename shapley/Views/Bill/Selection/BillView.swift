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
    
    init(meta: ModelPaths) {
        self._viewModel = StateObject(wrappedValue: BillModel(meta: meta))
    }
    
         
    var body: some View {
        ZStack{
            Color.khaki
                .ignoresSafeArea()
            VStack {
                if viewModel.isValid() {
                    
                    HStack {
                        Spacer()
                        Image(systemName: "newspaper.circle")
                        Text("Shapley")
                        
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(Color(.secondaryLabel))
                    .frame(height: 10)
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Split Bill")
                                .font(Font(CTFont(.system, size: 50)))
                                .bold()
                                .shadow(radius: 10)
                            Text("Swipe to select")
                                .font(.headline)
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                        Spacer()
                    }
                    .frame(height: 200)
                    .padding()
                    
                    BillSummaryView(viewModel: viewModel, isPresented: $isGroupPresented)
                        .padding(.horizontal)
                    
                    VStack {
                        ScrollView(.vertical, showsIndicators: true){
                            LazyVStack(spacing: 0) {
                                ForEach(Array(viewModel.getSales().enumerated()), id: \.element.id) { index, item in
                                    ItemBillView(sale: item,
                                                 user: viewModel.userModel!,
                                                 updateAction: viewModel.setItem(itemId:quantity:),
                                                 isFirst: index == 0)
                                    .scrollTransition(.interactive,
                                                      axis: .vertical) { view, phase in
                                        view.scaleEffect(phase.isIdentity ? 1.0 : 0)
                                            .opacity(phase.isIdentity ? 1.0 : 0)
                                    }
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                    }
                    .mask {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.black)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.gunMetal)
                            .shadow(radius: 15.0)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
        }
        .sheet(isPresented: $isGroupPresented) {
            ManageBillGroupView(meta: viewModel.getMeta())
                .ignoresSafeArea()
                .background {
                    Color.walnutBrown
                }
        }
        .navigationBarBackButtonHidden()
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
    BillView(meta: ModelPaths(id: "DkUXKLdl3wDRyl5iPdrs",
                            userId: "mKDySPyahSVrtLMjvALFxleBRm52",
                            activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316"))
}
