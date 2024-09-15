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
                    HStack {
                        TextField(viewModel.getTitle(), text: $editedTitle)
                        .onSubmit {
                            viewModel.updateTitle(name: editedTitle)
                            isEditing = false
                        }
                        .foregroundStyle(Color(.secondaryLabel))
                    }
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
    ExpenseView(metadata: MetaExpense(id: "37JuDhLT5ilrdryobZzH",
                                      userId: "10b8fa78neXKKsaGdiZvbnzDCN62",
                                      activityId: "3220F83A-136D-4FF2-912A-38F5AFF12316",
                                      type: .Vendue,
                                      dateCreated: TimeInterval()))
}
