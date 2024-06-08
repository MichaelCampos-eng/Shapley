//
//  User.swift
//  shapley
//
//  Created by Michael Campos on 5/22/24.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
