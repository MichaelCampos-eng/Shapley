//
//  Model.swift
//  shapley
//
//  Created by Michael Campos on 7/3/24.
//

import Foundation
import FirebaseFirestore

struct Model: Codable, Identifiable {
    @DocumentID var id: String?
    let title: String
    let createdDate: TimeInterval
    let type: ExpenseType
    
    enum ModelKeys: String, CodingKey {
        case id
        case title
        case createdDate
        case type
    }
    
    init(id: String? = nil,
         title: String,
         createdDate: TimeInterval,
         type: ExpenseType) {
        self.id = id
        self.title = title
        self.createdDate = createdDate
        self.type = type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ModelKeys.self)
        title = try container.decode(String.self, forKey: .title)
        createdDate = try container.decode(TimeInterval.self, forKey: .createdDate)
        type = try container.decode(ExpenseType.self, forKey: .type)
        
        if let idContainer = try? decoder.container(keyedBy: ModelKeys.self) {
            let id = try? idContainer.decode(String.self, forKey: .id)
            self.id = id
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ModelKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(type, forKey: .type)
        
        if let id = id {
            let firestoreEncoder = Firestore.Encoder()
            let encoded = try firestoreEncoder.encode(["id": id])
            if let mapId = encoded["id"] as? String {
                try container.encode(mapId, forKey: .id)
            }
        }
    }
    
}
