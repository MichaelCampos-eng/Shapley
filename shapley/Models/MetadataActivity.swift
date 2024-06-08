//
//  MetadataActivity.swift
//  shapley
//
//  Created by Michael Campos on 6/7/24.
//

import Foundation

struct MetadataActivity: Codable, Identifiable {
    let id: String
    let title: String
    let createdDate: TimeInterval
}
