//
//  ItemBillViewModel.swift
//  shapley
//
//  Created by Michael Campos on 7/22/24.
//

import Foundation
import Combine

class ItemBillViewModel: ObservableObject {
    @Published var selected: Int
    private var cancellables = Set<AnyCancellable>()
    
    private let saleItem: Sale
    private let upper: Int
    private let updateAction: (String, Int) -> Void
    
    init(selectedQuantity: Int?, saleItem: Sale, action: @escaping (String, Int) -> Void) {
        self.selected = selectedQuantity ?? 0
        self.saleItem = saleItem
        self.updateAction = action
        self.upper = selectedQuantity ?? 0 + saleItem.available
        self.setupSelectSave()
    }
    
    func add() {
        let modified = selected + 1
        selected = modified.clipped(to: 0...upper)
    }
    
    func subtract() {
        let modified = selected - 1
        selected = modified.clipped(to: 0...upper)
    }

    private func setupSelectSave() {
        $selected
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink { [weak self] val in
                if let self = self {
                    self.updateAction(self.saleItem.id, val)
                }
            }
            .store(in: &cancellables)
    }
}
