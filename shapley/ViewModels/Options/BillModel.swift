//
//  SplitBillModel.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import Foundation

class BillModel: ObservableObject {
    @Published var showingNewItemView = false
    private let meta: MetaTrip
    
    init(meta: MetaTrip) {
        self.meta = meta
    }
    
    
}
