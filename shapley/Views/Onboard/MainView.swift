//
//  MainView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    init() {
//        let appearance = UITabBarAppearance()
//        appearance.configureWithTransparentBackground()
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView()
        } else {
            LoginView()
        }
    }
    
    
    @ViewBuilder
    func accountView() -> some View {
        TabView {
            ActivitiesView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Home", systemImage: "house.circle")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .tint(Color.walnutBrown)
        
    }
}

#Preview {
    MainView()
}
