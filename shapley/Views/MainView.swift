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
            accountView()
        } else {
            // Show login screen
            LoginView()
        }
    }
    
    
    @ViewBuilder
    func accountView() -> some View {
        TabView {
            ActivitiesView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
        
}

#Preview {
    MainView()
}
