//
//  GroupBill.swift
//  shapley
//
//  Created by Michael Campos on 7/26/24.
//

import Foundation

struct ModelPaths: Hashable {
    let id: String
    let userId: String
    let activityId: String
}

struct BillGroup {
    let receipt: Receipt
    let validUsers: [ModelPaths]
}

struct UserClaims {
    let alias: String
    let claims: [Claim]
}

struct Claim: Equatable {
    let itemName: String
    let quantityClaimed: Int
    let unitPrice: Double
}
