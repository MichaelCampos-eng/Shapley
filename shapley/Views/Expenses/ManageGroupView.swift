//
//  ManageGroupView.swift
//  shapley
//
//  Created by Michael Campos on 6/14/24.
//

import SwiftUI

struct ManageGroupView: View {
    
    @Binding var groupViewPresented: Bool
    @StateObject var viewModel: ManageGroupViewModel
        
    init(presented: Binding<Bool>, activityId: String) {
        self._groupViewPresented = presented
        self._viewModel = StateObject(wrappedValue: ManageGroupViewModel(activityId: activityId))
    }
    
    var body: some View {
            VStack {
                List(viewModel.validUsers, id: \.self) { item in
                    ManageUserView(userId: item, activityId: viewModel.getActivityId())
                }
                .listStyle(PlainListStyle())
                Button("Dismiss") {
                    groupViewPresented = false
                }
                Spacer()
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
