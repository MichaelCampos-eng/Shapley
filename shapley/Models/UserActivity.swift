//
//  Item.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import Foundation

struct UserActivity: Codable, Identifiable {
    let admin: Bool
    let id: String
    var groupId: String
    
    // TODO: Use below as template for
    mutating func changeGroupId(_ state: String) {
        groupId = state
    }
}
