//
//  TripView.swift
//  shapley
//
//  Created by Michael Campos on 6/14/24.
//

import FirebaseFirestore
import SwiftUI

struct TripView: View {
    
    @StateObject var viewModel: TripViewModel
    @State private var isEditing = false
    @State private var editedTitle = ""
    
    @FirestoreQuery var userBill: [UserBill]
    @FirestoreQuery var model: [Model]
        
    init(metadata: MetaTrip) {
        self._userBill = FirestoreQuery(collectionPath: "users/\(metadata.userId)/activities/\(metadata.activityId)/models",
                                        predicates: [.where("id", isEqualTo: metadata.id)])
        self._model = FirestoreQuery(collectionPath: "activities/\(metadata.activityId)/models",
                                     predicates: [.where("id", isEqualTo: metadata.id)])
        self._viewModel = StateObject(wrappedValue: TripViewModel(meta: metadata))
    }
    
    var body: some View {
        if viewModel.validate(bill: userBill, model: model) {
            HStack {
                if isEditing {
                    
                } else {
                    NavigationLink(destination: ExpenseContentView()) {
                        VStack(alignment: .leading) {
                            Text(viewModel.getTitle())
                                .font(.body)
                                .bold()
                            Text("\(Date(timeIntervalSince1970: viewModel.getCreatedDate()).formatted(date: .abbreviated, time: .shortened))")
                                .font(.footnote)
                                .foregroundStyle(Color(.secondaryLabel))
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
    TripView(metadata: MetaTrip(id: "", userId: "", activityId: ""))
}
