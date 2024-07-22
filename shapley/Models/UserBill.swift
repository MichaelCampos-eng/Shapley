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
