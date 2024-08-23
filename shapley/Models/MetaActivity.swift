//
//  MetaActivity.swift
//  shapley
//
//  Created by Michael Campos on 6/7/24.
//

import Foundation

struct MetaActivity: Codable, Identifiable, Hashable {
    let id: String
    let titleName: String
    let userId: String
    let createdDate: TimeInterval
}
