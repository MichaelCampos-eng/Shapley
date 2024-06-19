//
//  Item.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import Foundation

struct UserActivity: Codable, Identifiable, Equatable {
    let id: String
    let isAdmin: Bool
    var tempName: String
    
    mutating func changeTempName(_ state: String) {
        tempName = state
    }
    
}
