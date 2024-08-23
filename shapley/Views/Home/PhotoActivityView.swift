//
//  PhotoActivityView.swift
//  shapley
//
//  Created by Michael Campos on 8/20/24.
//

import SwiftUI

struct PhotoActivityView: View {
    private var photoName: String
    
    init(name: String) {
        self.photoName = name
    }
    
    var body: some View {
        Image(photoName)
            .resizable()
            .clipShape(Rectangle())
            .overlay(Color.walnutBrown.opacity(0.6), in: Rectangle())
            .overlay(LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.clear]),
                startPoint: .bottom,
                endPoint: .top
            ), in: Rectangle())
    }
}

#Preview {
    PhotoActivityView(name: "photo3")
}
