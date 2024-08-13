//
//  FIllerBuildView.swift
//  shapley
//
//  Created by Michael Campos on 8/5/24.
//

import SwiftUI

struct FillerBuildView: View {
    
    @State private var animateGradient: Bool = false
    var body: some View {
        Rectangle()
            .overlay {
                LinearGradient(colors: [Color.prussianBlue, Color.roseTaupe],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .hueRotation(.degrees(animateGradient ? 45 : 0))
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    FillerBuildView()
}
