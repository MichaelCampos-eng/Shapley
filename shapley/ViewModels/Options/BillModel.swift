//
//  SplitBillModel.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import Foundation
import FirebaseFirestore

class BillModel: ObservableObject {
    @Published var model: Model?
    @Published var userModel: UserBill?
    
    private let meta: MetaExpense
    
    init(meta: MetaExpense) {
        self.meta = meta
        self.fetchModel()
        self.fetchUserModel()
    }
    
    private func fetchModel() {
        let db = Firestore.firestore()
        db.collection("activities/\(self.getActivityId())/models").document(self.getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let model = try? snapshot?.data(as: Model.self) else {
                print("Failed to decode model or document with that id does not exist.")
                return
            }
            self?.model = model
        }
    }
    
    private func fetchUserModel() {
        let db = Firestore.firestore()
        db.collection("users/\(self.getUserId())/activities/\(self.getActivityId())/models").document(self.getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let userModel = try? snapshot?.data(as: UserBill.self) else {
                print("Failed to decode user mode or document with that id does not exist.")
                return
            }
            self?.userModel = userModel
        }
    }
    
    func isValid() -> Bool {
        if model != nil && userModel != nil {
            return true
        }
        return false
    }
    
    func getTotal() -> Double {
        switch self.model!.type {
        case .Bill(let receipt):
            return receipt.summary.total
        default:
            return 0.0
        }
    }
    
    func getUserAmount() -> Double {
        let claims = userModel!.claims
        let sales = getSales()
        var amount = 0.0
        for (key, value) in claims {
            if let index = sales.firstIndex(where: {$0.id ==  key}) {
                let unitPrice = Double(String(format: "%.2f",  sales[index].price / Double(sales[index].quantity) )) ?? 0.0
                amount += unitPrice * Double(value)
            }
        }
        return amount
    }
    
    func setItem(itemId: String, quantity: Int) {
        guard var item = getItem(itemId: itemId) else {
            print("Item with that id does not exist.")
            return
        }
        var user = userModel!
        
        let userAmount = user.claims[itemId] ?? 0
        let potential = min(item.available + userAmount, quantity)
        if potential == 0 {
            user.claims.removeValue(forKey: itemId)
        } else {
            user.claims[itemId] = potential
        }
        item.addAvailble(userAmount - potential)
        print(item.available)
        updateBill(bill: user, sale: item)
    }
    
    private func updateBill(bill: UserBill, sale: Sale) {
        let db = Firestore.firestore()
        let userModelRef = db.collection("users/\(self.getUserId())/activities/\(self.getActivityId())/models").document(self.getModelId())
        do {
            try userModelRef.setData(from: bill)
        } catch {
            print("Failed to store user model")
        }
        switch self.model!.type {
        case .Bill(let receipt):
            if let index = receipt.items.firstIndex(where: {$0.id == sale.id}) {
                var newReceipt = receipt
                var newModel = self.model!
                
                newReceipt.items[index] = sale
                newModel.type = .Bill(receipt: newReceipt)
                
                let modelRef = db.collection("activities/\(self.getActivityId())/models").document(self.getModelId())
                do {
                    try modelRef.setData(from: newModel)
                } catch {
                    print("Failed to store model.")
                }
            }
        default:
            return
        }
    }
    
    func getItem(itemId: String) -> Sale? {
        return self.getSales().first{ $0.id == itemId}
    }
    
    internal func getModelId() -> String {
        return meta.id
    }
    
    func getActivityId() -> String {
        return meta.activityId
    }
    
    func getUserId() -> String {
        return meta.userId
    }
    
    func isOwner() -> Bool {
        return userModel!.owner
    }
    
    func getTitle() -> String {
        return model!.title
    }
    
    func getUserTax() -> Double {
        return getTax() * getUserAmount() / getSubtotal()
    }
    
    func getUserGrandTotal() -> Double {
        return getUserTax() + getUserAmount()
    }
    
    private func getSubtotal() -> Double {
        switch self.model!.type {
            case .Bill(let receipt):
                return receipt.summary.subtotal
            default:
                return 0.0
        }
    }
    
    
    private func getTax() -> Double {
        switch self.model!.type {
            case .Bill(let receipt):
                return receipt.summary.tax
            default:
                return 0.0
        }
    }
    
    func getSales() -> [Sale] {
        switch self.model!.type {
            case .Bill(let receipt):
            return receipt.items
        default:
            return []
        }
    }
}
