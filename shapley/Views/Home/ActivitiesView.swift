//
//  ActivitiesView.swift
//  shapley
//
//  Created by Michael Campos on 5/28/24.
//


import FirebaseFirestoreSwift
import SwiftUI

struct ActivitiesView: View {
    @StateObject var viewModel: ActivitiesViewModel
    
    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue: ActivitiesViewModel(userId: userId))
    }
    
    var body: some View {
        
        ZStack {
                NavigationView {
                    List(viewModel.metadata) { item in
                        ActivityView(metadata: item)
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Activities")
                    .toolbar {
                        Button {
                            viewModel.showingNewActivity = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.orange)
                        }
                    }
                    .blur(radius: viewModel.showingNewActivity ? 2 : 0)
                }
                if viewModel.showingNewActivity {
   
                    Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.showingNewActivity = false
                                }
                                
                            }
                            .zIndex(1)
                        
                        NewActivityView(newItemPresented: $viewModel.showingNewActivity)
                            .zIndex(2)
                            .transition(AnyTransition
                                .asymmetric(insertion: .move(edge: .top),
                                            removal: .move(edge: .top))
                                    .combined(with: .opacity))
                    
                }
        }
        .animation(.default.speed(1.25), value: viewModel.showingNewActivity)
    }
}

#Preview {
    ActivitiesView(userId: "mKDySPyahSVrtLMjvALFxleBRm52")
}
