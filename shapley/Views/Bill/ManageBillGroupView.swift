//
//  ManageBillGroup.swift
//  shapley
//
//  Created by Michael Campos on 7/26/24.
//

import SwiftUI
import Charts

struct ManageBillGroupView: View {
    
//    @StateObject private var viewModel: ManageBillGroupModel
    
    init(meta: MetaExpense) {
//        self._viewModel = StateObject(wrappedValue: ManageBillGroupModel(meta: meta))
    }

    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                    ForEach(0 ..< 3) { i in
//                        Rectangle()
//                            .fill(Color.blue)
                        Color.blue
                            .cornerRadius(15)
                            .padding(.horizontal, 5)
                            .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/5)
                        
                            .overlay {
                                VStack(alignment: .leading) {
                                    
                                    HStack {
                                        Image(systemName: "person")
                                        Text("Harley \(i)")
                                            .bold()
                                            .font(.title3)
                                            .foregroundStyle(Color(.secondaryLabel))
                                    }
                                    
                                    HStack {
                                        Image(systemName: "banknote")
                                        Text("\(4.89 + Double(i))")
                                            .font(.callout)
                                    }
                                }
                            }
                            
                            .scrollTransition(.interactive,
                                              axis: .horizontal) { view, phase in
                                
                                view.opacity(phase.isIdentity ? 1.0 : 0)
                                    .offset(y: phase.isIdentity ? 0 : 50)
                                    .scaleEffect(phase.isIdentity ? 1 : 0)
                                    .blur(radius: phase.isIdentity ? 0 : 15)
                                    .rotationEffect(.degrees(phase.value > 0 ? -30 : 0))
                                    .rotationEffect(.degrees(phase.value < 0 ? 30 : 0))
                            }
                    }
                }
                .scrollTargetLayout()
            }
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    ManageBillGroupView(meta: MetaExpense(id: "", userId: "", activityId: "", type: .Vendue, dateCreated: TimeInterval()))
}
