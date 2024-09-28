//
//  MetaTrip.swift
//  shapley
//
//  Created by Michael Campos on 6/13/24.
//

import Foundation
import FirebaseFirestore

struct ModelPaths: Equatable, Hashable {
    var modelId: String?
    var userId: String?
    var activityId: String?
    
    init(modelId: String? = nil, userId: String? = nil, activityId: String? = nil) {
        self.modelId = modelId
        self.userId = userId
        self.activityId = activityId
    }
}

/// MetaExpense holds references for view models.
struct MetaExpense: Hashable {
    let paths: ModelPaths
    let type: ExpenseType
    let createdDate: TimeInterval
    
    /// Converts MetaExpense struct into a hash value depending on expense type.
    /// - Parameter hasher: NavigationLink value parameter takes in hashable object so that items can be uniquely identified and tracked by navigation system (state management).
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
    
    /// Compares two MetaExpense structs for detecting changes in data displayed in List
    /// - Parameters:
    ///   - lhs: Current MetaExpense
    ///   - rhs: To compare MetaExpense
    /// - Returns: If the MetaExpense structs are the same then no changes occured therefore returns true, false otherwise
    static func == (lhs: MetaExpense, rhs: MetaExpense) -> Bool {
        return lhs.paths == rhs.paths &&
        lhs.type == rhs.type &&
        lhs.createdDate == rhs.createdDate
    }
}

struct MetaActivity: Hashable {
    let paths: ModelPaths
    let titleName: String
    let createdDate: TimeInterval
}
