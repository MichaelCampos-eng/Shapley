//
//  NewItemView.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewModel()

        
    
    var body: some View {
        
       
        VStack {
            Text("New Item")
                .font(.system(size: 32))
                .bold()
                .padding()
            
            Form {
                TextField("Item Name", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                
                TextField("Price", text: $viewModel.value)
                    .keyboardType(.decimalPad)
                
                
                ButtonView(title: "Save",
                           background: Color.pink,
                           action: viewModel.save)
                
            }
        }
    
        
        
    }
}

#Preview {
    NewItemView()
}
