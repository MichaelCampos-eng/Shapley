//
//  GroupBill.swift
//  shapley
//
//  Created by Michael Campos on 7/26/24.
//
import SwiftUI
import Foundation

struct ModelPaths: Hashable {  
    let id: String
    let userId: String
    let activityId: String
}

struct DisplayUser: Hashable {
    let displayColor: Color = DisplayUserPallete.pallete1.randomElement()!
    let pathIds: ModelPaths
}

struct UserClaims {
    let alias: String
    let claims: [Claim]
    let taxPercentage: Double
    var subtotal: Double {
        return claims.reduce(0.0) { result, claim in
            result + (claim.unitPrice * Double(claim.quantityClaimed))
        }
    }
    var tax: Double {
        return subtotal * taxPercentage
    }
    var debt: Double {
        return subtotal + tax
    }
}

struct Claim: Equatable {
    let itemName: String
    let quantityClaimed: Int
    let unitPrice: Double
}
