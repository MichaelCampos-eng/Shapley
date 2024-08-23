//
//  SearchBarCustomView.swift
//  shapley
//
//  Created by Michael Campos on 8/22/24.
//

import SwiftUI

struct SearchBarCustomView: View {
    
    @Binding private var searchText: String
    @Binding private var isEditing: Bool
    
    init(search: Binding<String>, isEditing: Binding<Bool>) {
        self._searchText = search
        self._isEditing = isEditing
    }
    
    var body: some View {
        
        
        
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search for trip ", text: $searchText, onEditingChanged: { editing in
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    if editing {
                        isEditing = true
                    } else {
                        isEditing = false
                    }
                }
            })
                
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.gunMetal)
                .stroke(Color.white, lineWidth: 4)
        }
        
        
    }
}

#Preview {
    SearchBarCustomView(search: Binding(get: {return ""}, set: {_ in}),
                        isEditing: Binding(get: {return false}, set: {_ in}))
}
