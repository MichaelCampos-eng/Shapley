//
//  ItemView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import SwiftUI

struct ActivityView: View {
    let metadata: MetaActivity
    
    init(metadata: MetaActivity) {
        self.metadata = metadata
    }
    
    var body: some View {
        HStack {
            
            // TripExpensesView(userId: metadata.userId, activityId: metadata.id)
            
            NavigationLink(destination: TripExpensesView()) {
                VStack(alignment: .leading) {
                    Text(metadata.title)
                        .font(.body)
                        .bold()
                    Text("\(Date(timeIntervalSince1970: metadata.createdDate).formatted(date: .abbreviated, time: .shortened))")
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
    ActivityView(metadata: MetaActivity(userId: "example", 
                                        id: "123",
                                        title: "testing",
                                        createdDate: Date().timeIntervalSince1970))
}
