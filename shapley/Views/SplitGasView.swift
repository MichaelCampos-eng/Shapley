//
//  SplitGasView.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import SwiftUI

struct SplitGasView: View {
    @StateObject var viewModel = SplitGasModel()
    private let userId: String
    
    init (userId: String) {
        self.userId = userId
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SplitGasView(userId: "Example")
}
