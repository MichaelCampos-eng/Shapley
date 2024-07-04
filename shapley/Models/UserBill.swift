//
//  UserBill.swift
//  shapley
//
//  Created by Michael Campos on 7/3/24.
//

import Foundation

struct UserBill: Identifiable, Codable {
    let id: String
    let owner: Bool
    let claims: [String]
}
