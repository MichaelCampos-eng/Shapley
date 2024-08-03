//
//  GroupBill.swift
//  shapley
//
//  Created by Michael Campos on 7/26/24.
//

import Foundation

struct UserClaim {
    let itemName: String
    let quantityClaimed: Int
    let unitPrice: Double
}


struct GroupBill: Identifiable {
    let id: String
    let alias: String
    let claims: [UserClaim]
}
