//
//  Receipt.swift
//  shapley
//
//  Created by Michael Campos on 7/15/24.
//

import Foundation
import FirebaseFirestore

struct Receipt: Codable, Hashable {
    var summary: GeneralReceipt
    var items: [Sale]
}
