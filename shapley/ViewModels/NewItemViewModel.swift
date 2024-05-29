//
//  NewItemViewModel.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import Foundation


class NewItemViewModel: ObservableObject {
    @Published var title = ""
    @Published var value = ""
    
    
    init() {
        
    }
    
    public func save() -> Void {
        
    }
}
