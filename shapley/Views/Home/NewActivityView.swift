//
//  NewActivityView.swift
//  shapley
//
//  Created by Michael Campos on 5/28/24.
//

import SwiftUI

struct NewActivityView: View {
    @StateObject var viewModel = NewActivityViewModel()
    @Binding var newItemPresented: Bool
    @State var createActivity: Bool = true
    @Namespace private var animationSpacespace
    
    var body: some View {
        VStack {
            SliderActivityView(option1: $createActivity)
                .padding()
            if createActivity {
                VStack {
                    HStack {
                        TextField("",
                                  text: $viewModel.activityName,
                                  prompt: Text("Enter activity name").foregroundStyle(Color.walnutBrown).bold())
                        .tint(Color.gunMetal)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 25.0)
                                .fill(Color.khaki)
                        }
                        Button(action: {}, label: {
                            Image(systemName: "photo.badge.plus")
                                .foregroundStyle(Color.walnutBrown)
                        })
                    }
                    ButtonView(title: "Create",
                               background: Color.walnutBrown) {
                        if viewModel.canCreate {
                            viewModel.create()
                            newItemPresented = false
                        } else {
                            viewModel.showAlert = true
                        }
                    }
                }
                .transition(AnyTransition
                    .asymmetric(insertion: .move(edge: .trailing),
                                removal: .move(edge: .trailing))
                        .combined(with: .opacity))
            } else {
                VStack {
                    TextField("",
                              text: $viewModel.groupId,
                              prompt: Text("Enter group id").foregroundStyle(Color.walnutBrown).bold())
                    .tint(Color.gunMetal)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(Color.khaki)
                    }
                    ButtonView(title: "Join Group",
                               background: Color.walnutBrown,
                               action: {
                        if viewModel.canJoin {
                            viewModel.join()
                            newItemPresented = false
                        } else {
                            viewModel.showAlert = true
                        }
                    })
                }
                .transition(AnyTransition
                    .asymmetric(insertion: .move(edge: .leading),
                                removal: .move(edge: .leading))
                        .combined(with: .opacity))
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.almond)
        }
        .mask(RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.almond))
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.3), value: createActivity)
    }
}

#Preview {
    NewActivityView(newItemPresented: Binding(get: {
        return true
    }, set: { _ in
        return
    }))
}
