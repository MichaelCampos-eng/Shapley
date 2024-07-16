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
    let claims: [String]
    let createdDate: TimeInterval
}
