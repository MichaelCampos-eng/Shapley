//
//  ActivityContent.swift
//  shapley
//
//  Created by Michael Campos on 6/2/24.
//

import Foundation

struct ContentActivity: Codable, Identifiable, Equatable {
    let id: String
    let createdDate: TimeInterval
    var title: String
    var groupId: String
    
    // TODO: Use below as template for
    mutating func changeGroupId(_ state: String) {
        groupId = state
    }
    
    mutating func changeTitle(_ state: String) {
        title = state
    }
    
    // TODO: Add a a list of users who have list to this document
}

