//
//  Sale.swift
//  shapley
//
//  Created by Michael Campos on 6/24/24.
//
import Foundation

struct Sale: Codable, Identifiable, Equatable, Hashable {
    let id: String
    var name:  String
    var quantity: Int
    var price: Double
    var available: Int
    
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
                   lhs.price == rhs.price
        }
}
