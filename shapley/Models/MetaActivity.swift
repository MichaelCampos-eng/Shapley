//
//  MetaActivity.swift
//  shapley
//
//  Created by Michael Campos on 6/7/24.
//

import Foundation

struct MetaActivity: Codable, Identifiable, Hashable {
    let userId: String
    let id: String
    let createdDate: TimeInterval
}
