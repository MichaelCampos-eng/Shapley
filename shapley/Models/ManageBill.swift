//
//  GroupBill.swift
//  shapley
//
//  Created by Michael Campos on 7/26/24.
//
import SwiftUI
import Foundation

struct UserDisplayRefs {
    let paths: ModelPaths
    let displayColor: Color = DisplayUserPallete.pallete1.randomElement()!
}

struct Sale: Codable, Identifiable, Equatable, Hashable {
    let id: String
    var name:  String
    var quantity: Int
    var price: Double
    var available: Int
    var unitPrice: Double {
        return price / Double(quantity)
    }
    var progress: Double {
        return 1.0 - Double(available) / Double(quantity)
    }
    
    init(id: String, name: String, quantity: Int, price: Double) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.price = price
        self.available = quantity
    }
    
    mutating func addAvailble(_ val: Int) {
        let newAvailable = available + val
        available = newAvailable.clipped(to: 0...quantity)
    }

    func isValid() -> Bool {
        return !name.isEmpty && quantity > 0 && price > 0.0
    }
    
    static func == (lhs: Sale, rhs: Sale) -> Bool {
            return lhs.name == rhs.name &&
                   lhs.name == rhs.name &&
                   lhs.quantity == rhs.quantity &&
                   lhs.price == rhs.price &&
                lhs.available == rhs.available
        }
}

struct Claim: Equatable {
    let sale: Sale
    let quantityClaimed: Int
}

struct Invoice {
    let claims: [Claim]
    let taxPercentage: Double
    var subtotal: Double {
        return claims.reduce(0.0) { result, claim in
            result + (claim.sale.unitPrice * Double(claim.quantityClaimed))
        }
    }
    var tax: Double {
        return subtotal * taxPercentage
    }
    var debt: Double {
        return subtotal + tax
    }
}
