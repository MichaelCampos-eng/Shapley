//
//  SplitBillView.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import SwiftUI

struct SplitBillView: View {
    @StateObject var viewModel = SplitBillModel()
    private let userId: String
    
    init (userId: String) {
        self.userId = userId
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .navigationTitle("Split Bill")
            .toolbar {
                Button {
                    // Action
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView()
            }
        }
    }
}

#Preview {
    SplitBillView(userId: "Example")
}
