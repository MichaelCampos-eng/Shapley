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
    @State private var isEditing: Bool = false
    
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
                RoundedRectangle(cornerRadius: 50.0)
                    .fill(Color.prussianBlue)
                    .ignoresSafeArea()
                    .frame(height: 300)
                    .offset(y: -300)
                VStack {
//                    
//                    VStack {
//                        RoundedRectangle(cornerRadius: 25.0)
//                            .fill(Color.walnutBrown)
//                            .stroke(Color.almond, lineWidth: 3)
//                            .overlay {
//                                VStack(alignment: .leading) {
//                                    Text("Create New Activity")
//                                        .bold()
//                                    HStack {
//                                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                                            Image(systemName: "photo.badge.plus")
//                                                .tint(Color.white)
//                                        })
//                                        TextField("Activity Name", text: Binding(get: {""}, set: {_ in}))
//                                            .padding()
//                                            .background {
//                                                RoundedRectangle(cornerRadius: 25.0)
//                                                    .stroke(Color.brown, lineWidth: 2)
//                                            }
//                                        
//                                        Button(action: {}, label: {
//                                            Text("Create")
//                                                .tint(.white)
//                                                .bold()
//                                                .padding()
//                                                .background {
//                                                    RoundedRectangle(cornerRadius: 25.0)
//                                                        .fill(Color.orange)
//                                                }
//                                        })
//                                    }
//                                    .padding(.horizontal)
//                                }
//                                .padding()
//                            }
//                        
//                        HStack {
//                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
//                                .fill(Color.roseTaupe)
//                                .overlay {
//                                    VStack {
//                                        Text("Join Group")
//                                        TextField("Enter Group ID", text: Binding(get: {""}, set: {_ in}))
//                                            .foregroundStyle(Color.walnutBrown)
//                                            .padding()
//                                            .background {
//                                                RoundedRectangle(cornerRadius: 25.0)
//                                                    .stroke(Color.paleDogwood, lineWidth: 2)
//                                            }
//                                        Button(action: {}, label: {
//                                            Text("Join")
//                                                .tint(.white)
//                                                .bold()
//                                                .padding()
//                                                .background {
//                                                    RoundedRectangle(cornerRadius: 25.0)
//                                                        .fill(Color.orange)
//                                                }
//                                        })
//                                    }
//                                    .padding()
//                                }
//                                .frame(width: 250)
//                            Spacer()
//                            HStack {
//                                RoundedRectangle(cornerRadius: 25.0)
//                                    .fill(Color.almond)
//                            }
//                        }
//                        
//                    }
//                    .padding()
                    
                    // Tag
                    
                    if !isEditing {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Fair for")
                                Text("Everyone!")
                            }
                            .font(.system(size: 50, weight: .bold))
                            .foregroundStyle(Color(.secondaryLabel))
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                        
                    // Items
                    SearchBarCustomView(search: $searchText, isEditing: $isEditing).padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        if isEditing {
                                LazyHGrid(rows: searchRows, spacing: 0) {
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
                        else {
                            LazyHGrid(rows: defaultRows, spacing: 0) {
                                ForEach(suggestions) { item in
                                    NavigationLink(value: item) {
                                        ActivityView(metadata: item)
                                            .padding(.horizontal)
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
                    }
                    .frame(height: isEditing ? 200 : 300)
                    .scrollTargetBehavior(.viewAligned)
                    .navigationDestination(for: MetaActivity.self) { item in
                        TripExpensesView(userId: item.userId, activityId: item.id)
                            .environmentObject(navigation)
                    }
                    .navigationTitle("Home")
                    .toolbar {
                        Button {
                            viewModel.showingNewActivity = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                    }
                    .blur(radius: viewModel.showingNewActivity ? 2 : 0)
                    Spacer()
                }
                .ignoresSafeArea(.keyboard)
                if viewModel.showingNewActivity {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                viewModel.showingNewActivity = false
                            }
                        }
                    NewActivityView(newItemPresented: $viewModel.showingNewActivity)
                        .transition(AnyTransition
                            .asymmetric(insertion: .move(edge: .top),
                                        removal: .move(edge: .top))
                                .combined(with: .opacity))
                }
            }
            
            .animation(.default.speed(1.25), value: viewModel.showingNewActivity)
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
