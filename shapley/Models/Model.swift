//
//  Model.swift
//  shapley
//
//  Created by Michael Campos on 7/3/24.
//

import Foundation

struct Model: Codable, Identifiable {
    let id: String
    let type: String 
    let title: String
    let createdDate: TimeInterval
}
