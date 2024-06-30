//
//  Sale.swift
//  shapley
//
//  Created by Michael Campos on 6/24/24.
//

import Foundation

struct Sale: Codable, Identifiable {
    let id: String
    var name:  String
    var quantity: Int
    var price: Double
}
