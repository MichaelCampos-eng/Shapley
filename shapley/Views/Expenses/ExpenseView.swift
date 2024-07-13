//
//  TripView.swift
//  shapley
//
//  Created by Michael Campos on 6/14/24.
//

import FirebaseFirestore
import SwiftUI

struct ExpenseView: View {
    
    @StateObject var viewModel: ExpenseViewModel
    @State private var isEditing = false
    @State private var editedTitle = ""
    
    @FirestoreQuery var userBill: [UserBill]
    @FirestoreQuery var model: [Model]
        
    init(metadata: MetaTrip) {
        self._userBill = FirestoreQuery(collectionPath: "users/\(metadata.userId)/activities/\(metadata.activityId)/models",
                                        predicates: [.where("id", isEqualTo: metadata.id)])
        self._model = FirestoreQuery(collectionPath: "activities/\(metadata.activityId)/models",
                                     predicates: [.where("id", isEqualTo: metadata.id)])
        self._viewModel = StateObject(wrappedValue: ExpenseViewModel(meta: metadata))
    }
    
    var body: some View {
        if viewModel.validate(bill: userBill, model: model) {
            HStack {
                if isEditing {
                    
                } else {
                    NavigationLink(destination: expenseView(type: viewModel.getType(),
                                                            meta: viewModel.getMeta())) {
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
    
    @ViewBuilder
    private func expenseView(type: ExpenseType, meta: MetaTrip) -> some View {
        switch type {
        case .Bill:
            BillView(meta: meta)
        case .Gas:
            GasView(meta: meta)
        case .Vendue:
            VendueView(meta: meta)
        }
    }
}

#Preview {
    ExpenseView(metadata: MetaTrip(id: "", userId: "", activityId: ""))
}
