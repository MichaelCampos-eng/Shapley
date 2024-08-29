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
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    
    private var defaultRows = Array(repeating: GridItem(.flexible()), count: 2)
    private var searchRows = Array(repeating: GridItem(.flexible()), count: 1)
    
    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue: ActivitiesViewModel(userId: userId))
    }
    
    var body: some View {
        let suggestions = searchText == "" ? 
        viewModel.metadata :
        viewModel.metadata.filter { $0.titleName.lowercased().contains(searchText.lowercased()) }
        
        NavigationStack(path: $navigation.path) {
            ZStack {
                Color.khaki.ignoresSafeArea()
                    .navigationTitle("Home")
                    .toolbar {
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.3)) {
                                viewModel.showingNewActivity.toggle()
                            }
                        } label: {
                            Image(systemName: viewModel.showingNewActivity ? "arrow.turn.right.down" : "plus")
                                .rotationEffect(.degrees(viewModel.showingNewActivity ? 0 : 360))
                                .foregroundColor(.white)
                        }
                    }
                VStack {
                    RoundedRectangle(cornerRadius: 50.0)
                        .fill(Color.prussianBlue)
                        .ignoresSafeArea()
                        .overlay {
                            if !isSearching {
                                VStack {
                                    Spacer()
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Fair for")
                                            Text("Everyone!")
                                        }
                                        .font(.system(size: 50, weight: .bold))
                                        .foregroundStyle(Color(.secondaryLabel))
                                        Spacer()
                                    }
                                }
                                .padding()
                            }
                        }
                    SearchBarCustomView(search: $searchText, isEditing: $isSearching).padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: isSearching ? searchRows : defaultRows, spacing: 0) {
                                ForEach(suggestions) { item in
                                    NavigationLink(value: item) {
                                        ActivityView(metadata: item)
                                            .padding()
                                            .containerRelativeFrame(.horizontal, count: 2, spacing: 0)
                                            .scrollTransition(.interactive,
                                                              axis: .horizontal) { view, phase in
                                                view.scaleEffect(phase.value < 0 ? 0.8 : 1.0)
                                                    .blur(radius: phase.isIdentity ? 0.0 : 1.0)
                                            }
                                    }
                                }
                            }
                            .scrollTargetLayout()
                    }
                    .padding(.vertical)
                    .frame(height: isSearching ? 200 : 375)
                    .scrollTargetBehavior(.viewAligned)
                    .navigationDestination(for: MetaActivity.self) { item in
                        TripExpensesView(userId: item.userId, activityId: item.id)
                            .environmentObject(navigation)
                    }
                }
                .offset(CGSize(width: 0.0, height: -50.0))
                if viewModel.showingNewActivity {
                    Color.clear
                        .ignoresSafeArea()
                        .zIndex(2.0)
                        .background(.ultraThinMaterial)
                        .onTapGesture {
                            withAnimation {
                                if viewModel.showingNewActivity {
                                    viewModel.showingNewActivity.toggle()
                                }
                            }
                        }
                    NewActivityView(newItemPresented: $viewModel.showingNewActivity)
                        .padding()
                        .frame(height: 275)
                        .transition(AnyTransition
                            .asymmetric(insertion: .move(edge: .top),
                                        removal: .move(edge: .bottom))
                                .combined(with: .opacity))
                        .zIndex(3.0)
                }
                Spacer()
            }
            .onChange(of: navigation.path) {
                if navigation.path.count == 0 {
                    viewModel.beginListening()
                }
                else {
                    viewModel.endListening()
                }
            }
        }
    }
}

#Preview {
    ActivitiesView(userId: "mKDySPyahSVrtLMjvALFxleBRm52")
}
