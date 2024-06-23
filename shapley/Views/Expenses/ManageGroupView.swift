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
    
    // May have to remove the following
    @State var isSearching: Bool = false
    
    init(presented: Binding<Bool>, activityId: String) {
        self._groupViewPresented = presented
        self._viewModel = StateObject(wrappedValue: ManageGroupViewModel(activityId: activityId))
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.results, id: \.self) { item in
                ManageUserView(userId: item, activityId: viewModel.getActivityId()) {userName, uId in
                    viewModel.users[userName] = uId
                }
            }
            .searchable(text: $viewModel.search, prompt: "Look for user")
            .listStyle(PlainListStyle())
            Button("Dismiss") {
                groupViewPresented = false
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
