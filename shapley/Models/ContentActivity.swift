//
//  ActivityContent.swift
//  shapley
//
//  Created by Michael Campos on 6/2/24.
//

import Foundation

struct ContentActivity: Codable, Identifiable {
    let id: String
    let title: String
    let createdDate: TimeInterval
    
    var groupId: String
    
    // TODO: Use below as template for
    mutating func changeGroupId(_ state: String) {
        groupId = state
    }
    
    // TODO: Add a a list of users who have list to this document
}

