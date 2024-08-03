//
//  ActivitiesView.swift
//  shapley
//
//  Created by Michael Campos on 5/28/24.
//

import FirebaseFirestoreSwift
import SwiftUI

class NavigationPathStore: ObservableObject {
    @Published var path = NavigationPath()
}

struct ActivitiesView: View {
    @StateObject private var viewModel: ActivitiesViewModel
    @StateObject private var navigation: NavigationPathStore = NavigationPathStore()
    
    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue: ActivitiesViewModel(userId: userId))
    }
    
    var body: some View {
        
        ZStack {
            NavigationStack(path: $navigation.path) {
                List(viewModel.metadata) { item in
                    NavigationLink(value: item) {
                        ActivityView(metadata: item)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Activities")
                .navigationDestination(for: MetaActivity.self) { item in
                    TripExpensesView(userId: item.userId, activityId: item.id)
                        .environmentObject(navigation)
                }
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
            .onChange(of: navigation.path) {
                if navigation.path.count == 0 {
                    viewModel.beginListening()
                }
                else {
                    viewModel.endListening()
                }
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
