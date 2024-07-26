//
//  TripView.swift
//  shapley
//
//  Created by Michael Campos on 6/14/24.
//

import SwiftUI

struct ExpenseView: View {
     
    @StateObject var viewModel: ExpenseViewModel
    @State private var isEditing = false
    @State private var editedTitle = ""
    
        
    init(metadata: MetaExpense) {
        self._viewModel = StateObject(wrappedValue: ExpenseViewModel(meta: metadata))
    }
    
    var body: some View {
        
        if viewModel.isAvailable() {
            HStack {
                if isEditing {
                    // TODO:  Add an editing feature, perhaps, not necessary, allow title changes
                } else {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.getTitle())
                                .font(.body)
                                .bold()
                            Text("\(Date(timeIntervalSince1970: viewModel.getCreatedDate()).formatted(date: .abbreviated, time: .shortened))")
                                .font(.footnote)
                                .foregroundStyle(Color(.secondaryLabel))
                        }
                        Spacer()
                        switch viewModel.getType() {
                        case .Bill:
                            Image(systemName: "newspaper.circle")
                        case .Gas:
                            Image(systemName: "car.circle")
                        case .Vendue:
                            Image(systemName: "bed.double.circle")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
            .swipeActions {
                if viewModel.isOwner() {
                    Button("Edit") {
                        isEditing = true
                    }
                    .tint(Color.blue)
                }
                Button("Delete") {
                    viewModel.delete()
                }
                .tint(Color.red)
            }
        }
    }
}

#Preview {
    ExpenseView(metadata: MetaExpense(id: "", userId: "", activityId: "", type: .Vendue, dateCreated: TimeInterval()))
}
