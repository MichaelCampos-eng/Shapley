//
//  SaleViewModel.swift
//  shapley
//
//  Created by Michael Campos on 6/26/24.
//

import Foundation
import Combine

class SaleViewModel: ObservableObject {
    
    @Published var quantity: Int = 0
    @Published var name: String = ""
    @Published var price: String = ""

    private var cancellables = Set<AnyCancellable>()
    
    private var updateSale: (String, Sale) -> Void
    private var fetchSale: (String) -> Sale
    
    private var saleId: String
    private var upper: Int = 20
    
    init(saleId: String, 
         fetch: @escaping (String) -> Sale,
         update: @escaping (String, Sale) -> Void) {
        self.saleId = saleId
        self.updateSale = update
        self.fetchSale = fetch
        self.priceUpdate()
    }
    
    public func getId() -> String {
        return self.saleId
    }
   
    private func priceUpdate() -> Void {
        $price
            .sink { [weak self] value in
                
                guard let id = self?.saleId else {
                    return
                }
                guard let sale = self?.fetchSale(id) else {
                    return
                }
                
                guard let newPrice = self?.filterToDecimal(value) else {
                    return
                }
                
                var newSale = sale
                newSale.price = atof(newPrice)
                self?.updateSale(id, newSale)
            }
            .store(in: &cancellables)
    }
    
    private func nameUpdate() -> Void {
        $name
            .sink { [weak self] value in
                guard let id = self?.saleId else {
                    return
                }
                
                guard let sale = self?.fetchSale(id) else {
                    return
                }
                
                var newSale = sale
                newSale.name = value
                self?.updateSale(id, newSale)
            }
            .store(in: &cancellables)
    }
    
    private func quantityUpdate() -> Void {
        $quantity
            .sink { [weak self] value in
                guard let id = self?.saleId else {
                    return
                }
                guard let sale = self?.fetchSale(id) else {
                    return
                }
                var newSale = sale
                newSale.quantity = value
                self?.updateSale(id, newSale)
            }
            .store(in: &cancellables)
    }
    
    private func filterToDecimal(_ value: String) -> String {
            var filtered = value.filter { "0123456789".contains($0) }
            filtered = filtered.trimmingCharacters(in: CharacterSet(charactersIn: "0"))

            if filtered.count > 5 {
                filtered = String(filtered.prefix(5))
            }
            if filtered.count >= 3 {
                let index = filtered.index(filtered.endIndex, offsetBy: -2)
                filtered.insert(".", at: index)
            } else if filtered.count == 2 {
                filtered = String(repeating: "0", count: 1) + "." +  filtered
            } else if filtered.count == 1 {
                filtered = String(repeating: "0", count: 2) + "." +  filtered
            }
            return filtered
        }
    
    private func limitText(_ value: String) -> String {
        var filtered = value
        if filtered.count > upper {
            filtered = String(filtered.prefix(upper))
        }
        return filtered
    }
}
