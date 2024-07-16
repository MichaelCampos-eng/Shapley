//
//  SplitGasView.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import SwiftUI

struct GasView: View {
    @StateObject var viewModel = GasModel()
    private let meta: MetaTrip
    
    init (meta: MetaTrip) {
        self.meta = meta
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    GasView(meta: MetaTrip(id: "", userId: "", activityId: "", dateCreated: TimeInterval()))
}
