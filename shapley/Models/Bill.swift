//
//  UserBill.swift
//  shapley
//
//  Created by Michael Campos on 7/3/24.
//

import Foundation
import FirebaseFirestore

struct UserBill: Codable {
    let owner: Bool
    var claims: [String: Int]
    let createdDate: TimeInterval
}

struct GeneralReceipt: Codable, Equatable, Hashable {
    var subtotal: Double
    var tax: Double
    
    var total: Double {
        return subtotal + tax
    }
    
    var taxPercentage: Double {
        return (total/subtotal) - 1.0
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

enum Field: Hashable {
    case receipt
    case summary
    case title
}
