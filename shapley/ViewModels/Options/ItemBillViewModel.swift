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
    
    let claim: Claim
    private lazy var upper: Int = { claim.quantityClaimed + claim.sale.available }()
    private let updateAction: (String, Int) async -> Void
    
    init(claim: Claim, action: @escaping (String, Int) async -> Void) {
        self.claim = claim
        self.selected = claim.quantityClaimed
        self.updateAction = action
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
                    Task {
                        await self.updateAction(self.claim.sale.id, val)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
