//
//  ExpenseContentModel.swift
//  shapley
//
//  Created by Michael Campos on 7/13/24.
//

import Foundation

class ExpenseContentModel: ObservableObject {
    
    private let meta: MetaExpense
    
    init(meta: MetaExpense) {
        self.meta = meta
    }
    
    
}
