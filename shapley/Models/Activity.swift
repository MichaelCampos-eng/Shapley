//
//  Item.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import Foundation

struct Activity: Codable, Identifiable {
    let id: String
    let title: String
    let createdDate: TimeInterval
    var isDone: Bool
    
    mutating func setDone(_ state: Bool) {
        isDone = state 
    }
}
