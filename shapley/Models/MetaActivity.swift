//
//  MetaActivity.swift
//  shapley
//
//  Created by Michael Campos on 6/7/24.
//

import Foundation

struct MetaActivity: Codable, Identifiable {
    let userId: String
    let id: String
    let title: String
    let createdDate: TimeInterval
}
