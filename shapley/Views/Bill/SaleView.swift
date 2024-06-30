//
//  SaleView.swift
//  shapley
//
//  Created by Michael Campos on 6/25/24.
//

import SwiftUI
import Combine

struct SaleView: View {
    
    @StateObject var viewModel: SaleViewModel
    private var deleteAction: (String) -> Void
    
    init(saleId: String,
         delete: @escaping (String) -> Void,
         update: @escaping (String, Sale) -> Void,
         fetch: @escaping (String) -> Sale) {
        
        self._viewModel = StateObject(wrappedValue: SaleViewModel(saleId: saleId,
                                                                  fetch: fetch,
                                                                  update: update))
        self.deleteAction = delete
    }
    
    
    var body: some View {
        
        HStack {
            TextField("Item Name", text: $viewModel.name)
                .fixedSize(horizontal: true, vertical: false)
            
            Picker("Quantity", selection: $viewModel.quantity) {
                ForEach(0...100, id: \.self) { number in
                    Text("\(number)")
                }
            }
            .tint(.orange)
            .labelsHidden()
            .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            
            Rectangle()
                .fill(.orange.opacity(0.00001))
                .fixedSize(horizontal: false, vertical: true)
                .onTapGesture {}
            
            Spacer()
            
            TextField("Price", text: $viewModel.price)
                .fixedSize(horizontal: true, vertical: false)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
        }
        .swipeActions {
            Button {
                deleteAction(viewModel.getId())
            } label: {
                Label("Delete", systemImage: "minus")
            }
            .tint(.red)
        }
    }
}

#Preview {
    SaleView(saleId: "",
             delete: ({_ in}),
             update: ({_, _ in}),
             fetch: ({_ in return Sale(id: "",
                                       name: "", 
                                       quantity: 0,
                                       price: 0.0)}))
}
