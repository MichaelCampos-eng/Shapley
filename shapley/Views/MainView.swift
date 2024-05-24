//
//  MainView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            // signed in
            ListView()
        } else {
            // Show login screen
            LoginView()
        }
    }
        
}

#Preview {
    MainView()
}
