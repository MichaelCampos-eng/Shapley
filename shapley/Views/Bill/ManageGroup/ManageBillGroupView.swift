//
//  ManageBillGroup.swift
//  shapley
//
//  Created by Michael Campos on 7/26/24.
//

import SwiftUI
import Charts

struct ManageBillGroupView: View {
    
    @StateObject private var viewModel: ManageBillGroupModel
    
    init(meta: ModelPaths) {
        self._viewModel = StateObject(wrappedValue: ManageBillGroupModel(meta: meta))
    }

    var body: some View {
        
        ZStack {
            Color.black
                .overlay {
                    FillerBuildView()
                }
                .ignoresSafeArea()
            if viewModel.isValid() {
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            Text("Hi, \(viewModel.getNickname())!")
                                .foregroundStyle(Color.paleDogwood)
                                .bold()
                                .font(.title)
                            Spacer()
                        }
                        DebtView(missing: viewModel.getMissingAmount(), total: viewModel.getTotal())
                            .frame(maxHeight: 100)
                    }
                    .padding(.horizontal)
                    GroupSalesView(items: viewModel.getSales())
                        .frame(maxHeight: 100)
                    GroupClaimsView(users: viewModel.getGroup())
                        .frame(maxHeight: 250)
                }
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    ManageBillGroupView(meta: ModelPaths(id: "cG1pKA6E7gCXkysxTD3o",
                                       userId: "10b8fa78neXKKsaGdiZvbnzDCN62",
                                       activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316"))
}
