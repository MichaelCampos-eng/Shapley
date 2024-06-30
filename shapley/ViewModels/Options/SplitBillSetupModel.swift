//
//  SplitBillSetupModel.swift
//  shapley
//
//  Created by Michael Campos on 6/24/24.
//

import Foundation
import Combine

class SplitBillSetupModel: ObservableObject {
    
    @Published var items: [Sale] = []
    @Published var subtotal: Double = 0.0
    private let activityId: String
    
    private var cancellables = Set<AnyCancellable>()
    
    init(activityId: String) {
        self.activityId = activityId
        self.fetchSubtotal()
    }
    
    public func get(id: String) -> Sale {
        let sale = items.filter( {$0.id == id} )
        return sale.first!
    }
    
    public func update(id: String, sale: Sale) {
        self.delete(id: id)
        items.append(sale)
    }
    
    public func delete(id: String) -> Void {
        items.removeAll { $0.id == id }
    }
        
    public func createNewEntry() -> Void {
        items.append(Sale(id: UUID().uuidString, name: "", quantity: 0, price: 0.0))
    }
    
    private func fetchSubtotal() -> Void {
        $items
            .map { values in
                return values.reduce(0) { $0 + $1.price }
            }
            .assign(to: \.subtotal, on: self)
            .store(in: &cancellables)
    }
}
