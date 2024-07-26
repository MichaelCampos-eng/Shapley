//
//  MetaTrip.swift
//  shapley
//
//  Created by Michael Campos on 6/13/24.
//

import Foundation
import FirebaseFirestore

struct MetaExpense: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let activityId: String
    let type: ExpenseType
    let dateCreated: TimeInterval
    
    func hash(into hasher: inout Hasher) {
            switch self.type {
            case .Bill(let receipt):
                hasher.combine(receipt)
            case .Gas:
                hasher.combine(2)
            case .Vendue:
                break
            }
        }
    
    static func == (lhs: MetaExpense, rhs: MetaExpense) -> Bool {
        return lhs.id == rhs.id &&
        lhs.userId == rhs.userId &&
        lhs.activityId == rhs.activityId &&
        lhs.type == rhs.type &&
        lhs.dateCreated == rhs.dateCreated
    }
}
