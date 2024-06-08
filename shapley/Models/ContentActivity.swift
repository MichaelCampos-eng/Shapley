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
}

