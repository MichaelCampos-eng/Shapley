//
//  SwipeActionView.swift
//  shapley
//
//  Created by Michael Campos on 6/26/24.
//

import SwiftUI

struct SwipeActionView<Content: View>: View {
    @State private var offset: CGFloat = 0
    @GestureState private var isDragging = false

    let content: Content
    let action: () -> Void

    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Spacer()
                Button(action: {
                    self.action()
                }) {
                    Label("Delete", systemImage: "minus")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.trailing, 20)
            }
            
            content
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 1)
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .updating($isDragging) { value, state, _ in
                            state = true
                            self.offset = value.translation.width
                        }
                        .onEnded { value in
                            withAnimation {
                                if value.translation.width < -100 {
                                    self.offset = -100
                                } else {
                                    self.offset = 0
                                }
                            }
                        }
                )
        }
        .padding(.horizontal, 10)
    }
}

struct SwipeActionView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeActionView(action: { print("Action") }) {
            Text("Swipe Me")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
        .frame(height: 60)
    }
}
