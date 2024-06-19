//
//  NewTripView.swift
//  shapley
//
//  Created by Michael Campos on 6/14/24.
//

import SwiftUI

struct NewTripView: View {
    
    
    @Binding var newTripPresented: Bool
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
}

#Preview {
    NewTripView(newTripPresented: Binding(get: {
        return true
    }, set: { _ in
        return
    }))
}
