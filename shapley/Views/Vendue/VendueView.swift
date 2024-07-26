//
//  VendueView.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import SwiftUI

struct VendueView: View {
    @StateObject var viewModel: VendueModel
    
    init (meta: MetaExpense) {
        self._viewModel = StateObject(wrappedValue: VendueModel(meta: meta))
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    VendueView(meta: MetaExpense(id: "", 
                                 userId: "",
                                 activityId: "",
                                 type: .Vendue,
                                 dateCreated: TimeInterval()))
}
