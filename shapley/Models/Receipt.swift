//
//  Receipt.swift
//  shapley
//
//  Created by Michael Campos on 7/15/24.
//

import Foundation
import FirebaseFirestore

struct Receipt: Codable, Hashable {
    var summary: GeneralReceipt
    var items: [Sale]
    
    var missingAmount: Double {
        let missingSubtotal = items.reduce(0.0) { (result, item) in
            return result + (Double(item.available) * item.unitPrice)
        }
        return missingSubtotal * (summary.taxPercentage + 1.0)
    }
    
    var progress: Double {
        return 1 -  ( missingAmount / summary.total)
    }
}
