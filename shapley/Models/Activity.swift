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
    var validUsers: [String]
    
    mutating func addUser(_ state: String) {
        validUsers.append(state)
    }
    
    mutating func removeUser(_ state: String) {
        validUsers =  validUsers.filter { $0 != state}
    }

    mutating func changeGroupId(_ state: String) {
        groupId = state
    }
    
    mutating func changeTitle(_ state: String) {
        title = state
    }
}

struct UserActivity: Codable, Identifiable, Equatable {
    let id: String
    let isAdmin: Bool
    var tempName: String
    
    mutating func changeTempName(_ state: String) {
        tempName = state
    }
}
