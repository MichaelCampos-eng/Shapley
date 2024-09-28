//
//  TESTING.swift
//  shapley
//
//  Created by Michael Campos on 8/2/24.
//

import SwiftUI

struct GroupClaimsView: View {
    @EnvironmentObject private var viewModel: ManageBillGroupModel
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(viewModel.group, id: \.paths.modelId) { refs in
                        UserClaimsView(receipt: viewModel.receipt!, refs: refs) 
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .scrollTransition(.interactive,
                                              axis: .horizontal) { view, phase in
                            view.offset(x: phase.value > 0 ? -20 : 0, y: phase.value > 0 ? 20 : 0)
                                .offset(y: phase.value < 0 ? 80 : 0)
                                .rotationEffect(.degrees(phase.value > 0 ? -10: 0))
                                .rotationEffect(.degrees(phase.value < 0 ?  -10 : 0))
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    GroupClaimsView()
}
