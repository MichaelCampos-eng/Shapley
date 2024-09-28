//
//  SplitGasView.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import SwiftUI

struct GasView: View {
    @StateObject var viewModel = GasModel()
    private let meta: MetaExpense
    
    init (meta: MetaExpense) {
        self.meta = meta
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    GasView(meta: MetaExpense(paths: ModelPaths(modelId: "",
                                           userId: "",
                                           activityId: ""),
                              type: .Gas,
                              createdDate: TimeInterval()))
}
