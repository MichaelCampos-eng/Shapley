//
//  ManageGroupView.swift
//  shapley
//
//  Created by Michael Campos on 6/14/24.
//

import SwiftUI

struct ManageGroupView: View {
    @StateObject var viewModel: ManageGroupViewModel
    @Binding var groupViewPresented: Bool
    
    init(presented: Binding<Bool>, activityId: String) {
        self._groupViewPresented = presented
        self._viewModel = StateObject(wrappedValue: ManageGroupViewModel(activityId: activityId))
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color.brown.ignoresSafeArea()
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(viewModel.results, id:\.self) { item in
                            ManageUserView(userId: item, activityId: viewModel.getActivityId()) { userName, uId in
                                viewModel.users[userName] = uId
                            }
                            .scrollTransition(.interactive,
                                              axis: .horizontal) { view, phase in
                                view.scaleEffect(phase.isIdentity ? 1.0 : 0.0)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .padding()
                .scrollTargetBehavior(.viewAligned)
                .searchable(text: $viewModel.search, prompt: "Look for user")
                .navigationTitle("Code: \(viewModel.getGroupCode())")
                .navigationBarTitleDisplayMode(.inline)
                .tint(.almond)
            
                .scrollContentBackground(.hidden)
            }
            
            
        }
    }
}

#Preview {
    ManageGroupView(presented: Binding(get: {
        return true
    }, set: { _ in
        return
    }), activityId: "6DE21F32-FBD8-4F26-94AC-5FA8B5EC1A5B")
}
