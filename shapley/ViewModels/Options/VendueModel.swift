//
//  VendueModel.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import Foundation

class VendueModel: ObservableObject {
    private let meta: MetaTrip
    init(meta: MetaTrip) {
        self.meta = meta
    }
}
