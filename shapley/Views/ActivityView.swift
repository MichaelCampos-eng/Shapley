//
//  ItemView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var viewModel = ActivityViewModel()
    let activity: Activity
    
    var body: some View {
        HStack {
            
            Button(action: {
                            viewModel.toggleIsDone(activity: activity)
                        }) {
                            Image(systemName: activity.isDone ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(Color.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
            
            
            // Wrap the VStack with NavigationLink
        
            NavigationLink(destination: SplitGasView(userId: "example")) {
                VStack(alignment: .leading) {
                    Text(activity.title)
                        .font(.body)
                        .bold()
                    Text("\(Date(timeIntervalSince1970: activity.createdDate).formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            
        }
        
    }
}

#Preview {
    ActivityView(activity: Activity(id: "123", title: "testing", createdDate: Date().timeIntervalSince1970, isDone: false))
}
