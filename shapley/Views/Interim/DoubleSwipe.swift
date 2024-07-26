

//
//  ActionButton.swift
//  SwipeActionsFromScratch
//
//  Created by Kit Langton on 9/20/23.
//

import SwiftUI
import Combine

struct SwipeActionsView<Content: View>: View {
    
    init(right: SwipeAction,
         left: SwipeAction,
         @ViewBuilder content: () -> Content) {
        self.right = right
        self.left = left
        self.content = content()
    }
    
    var content: Content
    
    @State private var offset: CGFloat = 0
    private let rightExpansionThresh: CGFloat = -100
    private let leftExpansionThresh: CGFloat = 100
    
    @State private var addTriggered = false
    @State private var removeTriggered = false
    
    private let right: SwipeAction
    private let left: SwipeAction
    
    @State private var rightTimer: Timer?
    @State private var leftTimer: Timer?
    private let latency: Double = 0.5
    private let period: Double = 0.1

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.interactiveSpring) {
                    offset = value.translation.width
                }
                removeTriggered = offset < rightExpansionThresh
                addTriggered = offset > leftExpansionThresh
            }
            .onEnded { _ in
                withAnimation {
                    offset = 0
                    removeTriggered = false
                    addTriggered = false
                }
            }
    }

    var body: some View {
        content
            .offset(x: offset)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .overlay(alignment: .leading) {
                ZStack(alignment: .leading) {
                    ForEach(Array(left.meta.enumerated()), id: \.offset) { index, symb in
                        if offset >= 0 {
                            let proportion = CGFloat(left.meta.count - index)
                            let isDefault = index == left.meta.count - 1
                            let width = isDefault && addTriggered ? offset : offset * proportion / CGFloat(left.meta.count)
                            LeftActionButton(width: width, symbol: symb)
                        }
                    }
                }
                .animation(.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 3.0), value: addTriggered)
                .onChange(of: addTriggered) { oldState, newState in
                    if oldState == false, newState == true {
                        leftExecute()
                    }
                    else if newState == false {
                        leftTerminate()
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
            .highPriorityGesture(dragGesture)
            
            .overlay(alignment: .trailing) {
                ZStack(alignment: .trailing) {
                    ForEach(Array(right.meta.enumerated()), id: \.offset) { index, symb in
                        if offset <= 0 {
                            let proportion = CGFloat(right.meta.count - index)
                            let isDefault = index == right.meta.count - 1
                            let width = abs(isDefault && removeTriggered ? offset : offset * proportion / CGFloat(right.meta.count))
                            RightActionButton(width: width, symbol: symb)
                        }
                    }
                }
                .animation(.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 3.0), value: removeTriggered)
                .onChange(of: removeTriggered) { oldState, newState in
                    if oldState == false, newState == true {
                        rightExecute()
                    }
                    else if newState == false {
                        rightTerminate()
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
            .highPriorityGesture(dragGesture)
    }
    
    private func leftExecute() {
        leftTimer?.invalidate()
        self.left.execute()
        self.leftTimer = Timer.scheduledTimer(withTimeInterval: latency, repeats: false) { _ in
            self.leftExecuteRepeat()
        }
    }
    
    private func leftExecuteRepeat() {
        leftTimer?.invalidate()
        self.leftTimer = Timer.scheduledTimer(withTimeInterval: period, repeats: true) { _ in
            self.left.execute()
        }
    }
    
    private func leftTerminate() {
        leftTimer?.invalidate()
    }
    
    private func rightExecute() {
        rightTimer?.invalidate()
        self.right.execute()
        self.rightTimer = Timer.scheduledTimer(withTimeInterval: latency, repeats: false) { _ in
            self.rightExecuteRepeat()
        }
    }
    
    private func rightExecuteRepeat() {
        rightTimer?.invalidate()
        self.rightTimer = Timer.scheduledTimer(withTimeInterval: period, repeats: true) { _ in
            self.right.execute()
        }
    }
    
    private func rightTerminate() {
        rightTimer?.invalidate()
    }
   
}

struct RightActionButton: View {
    var width: CGFloat
    let symbol: ActionSymbol
    
    init(width: CGFloat, symbol: ActionSymbol) {
        self.width = width
        self.symbol = symbol
    }
    
    var body: some View {
        symbol.color
            .overlay(alignment: .leading) {
                Label(symbol.name, systemImage: symbol.systemIcon)
                    .labelStyle(.iconOnly)
                    .padding(.leading)
            }
            .clipped()
            .frame(width: width)
            .font(.title2)
    }
}

struct LeftActionButton: View {
    var width: CGFloat
    let symbol: ActionSymbol
    
    init(width: CGFloat, symbol: ActionSymbol) {
        self.width = width
        self.symbol = symbol
    }
    
    var body: some View {
        symbol.color
            .overlay(alignment: .trailing) {
                Label(symbol.name, systemImage: symbol.systemIcon)
                    .labelStyle(.iconOnly)
                    .padding( .trailing)
            }
            .clipped()
            .frame(width: width)
            .font(.title2)
    }
}

struct SwipeAction {
    let meta: [ActionSymbol]
    let execute: () -> Void
}

struct ActionSymbol: Identifiable {
    let id = UUID()
    let color: Color
    let name: String
    let systemIcon: String
}

#Preview {
    SwipeActionsView(
        right: SwipeAction(meta: [ActionSymbol(color: .gray,
                                               name: "Remove",
                                               systemIcon: "arrow.left"),
                                  ActionSymbol(color: .red,
                                               name: "Remove from cart",
                                               systemIcon: "cart.badge.minus")],
                           execute: {}),
        left: SwipeAction(meta: [ActionSymbol(color: .gray,
                                              name: "Add",
                                              systemIcon: "arrow.right"),
                                 ActionSymbol(color: .orange,
                                              name: "Add to cart",
                                              systemIcon: "cart.badge.plus")],
                          execute: {})
    ){
        Text("**TESTING SWIPE GESTURE**").font(.title)
    }
}
