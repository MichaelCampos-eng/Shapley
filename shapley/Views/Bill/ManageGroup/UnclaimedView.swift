//
//  UnclaimedView.swift
//  shapley
//
//  Created by Michael Campos on 8/9/24.
//

import SwiftUI

struct UnclaimedView: View {
    
    private var item: Sale
    @State private var progress: Double
    
    init(item: Sale) {
        self.item = item
        self._progress = State(initialValue: 0.0)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0)
                .fill(Color.black.opacity(0.5))
            
                VStack(alignment: .leading) {
                    Spacer()
                    Text(item.name)
                        .font(.caption)
                        .foregroundStyle(Color(.secondaryLabel))
                    Text("\(item.available) left")
                        .foregroundStyle(Color.white)
                        .font(.title3)
                        .foregroundStyle(Color.white)
                        .bold()
                    // Progress bar
                    GeometryReader { metrics in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 25.0)
                                .frame(height: 10)
                                .foregroundStyle(Color.gray.opacity(0.5))
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .frame(width: metrics.size.width * progress, height: 10)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.orange, .maize]),
                                                                startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/,
                                                                endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                                .animation(.bouncy, value: progress)
                        }
                    }
                    Spacer()
                }
                .padding()
            
        }
        .onAppear {
            withAnimation {
                updateProgress()
            }
        }
    }
    
    private func updateProgress() {
        withAnimation {
            self.progress = 1
        }
    }
}

#Preview {
    UnclaimedView(item: Sale(id: "", 
                             name: "sghsdfh",
                             quantity: 24,
                             price: 46.46))
}
