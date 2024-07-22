//
//  Clip.swift
//  shapley
//
//  Created by Michael Campos on 7/18/24.
//

import Foundation

extension Comparable {
    func clipped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
