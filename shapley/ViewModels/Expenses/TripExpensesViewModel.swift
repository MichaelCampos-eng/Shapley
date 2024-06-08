//
//  TripExpensesModel.swift
//  shapley
//
//  Created by Michael Campos on 6/2/24.
//

import Foundation

class TripExpensesViewModel: ObservableObject {
    
    let activityId: String
    
    init(activityId: String) {
        self.activityId = activityId
    }
    
}

