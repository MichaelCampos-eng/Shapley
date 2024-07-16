//
//  MetaTrip.swift
//  shapley
//
//  Created by Michael Campos on 6/13/24.
//

import Foundation
import FirebaseFirestore

struct MetaTrip: Identifiable, Codable {
    let id: String
    let userId: String
    let activityId: String
    let dateCreated: TimeInterval
}
