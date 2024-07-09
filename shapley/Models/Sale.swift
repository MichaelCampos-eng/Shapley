//
//  Sale.swift
//  shapley
//
//  Created by Michael Campos on 6/24/24.
//

import Foundation

struct Sale: Codable, Identifiable, Equatable {
    let id: String
    var name:  String
    var quantity: Int
    var price: Double
    
    func isValid() -> Bool {
        return !name.isEmpty && quantity > 0 && price > 0.0
    }
    
    static func == (lhs: Sale, rhs: Sale) -> Bool {
            return lhs.name == rhs.name &&
                   lhs.name == rhs.name &&
                   lhs.quantity == rhs.quantity &&
                   lhs.price == rhs.price
        }
}
