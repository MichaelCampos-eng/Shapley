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
        if viewModel.isValid() {
            VStack {
                Capsule()
                    .frame(width: 40, height: 5)
                    .foregroundStyle(Color.gunMetal)
                    .padding()
                Text("Group Details")
                    .foregroundStyle(Color(.secondaryLabel))
                    .font(.title3)
                    .bold()
                Spacer()
                VStack {
                    HStack {
                        Text("Hi, \(viewModel.nickName!)!")
                            .foregroundStyle(Color.white)
                            .bold()
                            .font(.largeTitle)
                            .shadow(radius: 10)
                        Spacer()
                    }
                    DebtView()
                        .frame(maxHeight: 100)
                }
                .padding(.horizontal)
                GroupSalesView()
                    .frame(maxHeight: 100)
                GroupClaimsView()
                    .frame(maxHeight: 250)
            }
            .environmentObject(viewModel)
        }
    }
}

#Preview {
    ManageBillGroupView(meta: ModelPaths(id: "cG1pKA6E7gCXkysxTD3o",
                                       userId: "10b8fa78neXKKsaGdiZvbnzDCN62",
                                       activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316"))
}
