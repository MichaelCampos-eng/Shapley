//
//  GeneralReceipt.swift
//  shapley
//
//  Created by Michael Campos on 7/5/24.
//

import Foundation

struct GeneralReceipt: Codable, Equatable, Hashable {
    var subtotal: Double
    var tax: Double
    
    var total: Double {
        return subtotal + tax
    }

    mutating func changeSubtotal(_ state: Double) {
        subtotal = state
    }
    
    mutating func changeTax(_ state: Double) {
        tax = state
    }
    
    static func == (lhs: GeneralReceipt, rhs: GeneralReceipt) -> Bool {
            return lhs.subtotal == rhs.subtotal &&
                   lhs.tax == rhs.tax
        }
}
