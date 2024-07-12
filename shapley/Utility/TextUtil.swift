//
//  TextUtil.swift
//  shapley
//
//  Created by Michael Campos on 7/9/24.
//

import Foundation

class TextUtil {
    static func formatDecimal(_ value: String) -> String {
            if value == "" {
                return value
            }
            var filtered = value.filter { "0123456789".contains($0) }
            while filtered.hasPrefix("0") {
                filtered.removeFirst()
            }
            
            let num = filtered.count
            let nec = 3 - num
            if nec > 0 {
                filtered = String(repeating: "0", count: nec) + filtered
            }
            let index = filtered.index(filtered.endIndex, offsetBy: -2)
            filtered.insert(".", at: index)
            return filtered
        }
    
    static func limitText(_ value: String, _ upper: Int) -> String {
        var filtered = value
        if filtered.count > upper {
            filtered = String(filtered.prefix(upper))
        }
        return filtered
    }
}
