//
//  ExpenseType.swift
//  shapley
//
//  Created by Michael Campos on 7/13/24.
//

import Foundation

enum ExpenseType: Codable, Equatable {
    case Bill(receipt: Receipt)
    case Gas
    case Vendue
}
