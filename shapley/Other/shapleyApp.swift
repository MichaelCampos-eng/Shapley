//
//  shapleyApp.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import FirebaseCore
import SwiftUI

@main
struct shapleyApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
