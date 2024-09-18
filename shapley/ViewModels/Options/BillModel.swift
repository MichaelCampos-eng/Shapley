//
//  SplitBillModel.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import FirebaseFirestore
import Foundation
import Combine

class BillModel: ObservableObject {
    @Published var receipt: Receipt?
    
    @Published private var userModel: UserBill?
    @Published var userInvoice: Invoice?
    
    private var receiptReg: ListenerRegistration?
    private var userReg: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    private let meta: ModelPaths
    
    init(meta: ModelPaths) {
        self.meta = meta
        beginListening()
    }
    
    private func beginListening() {
        self.fetchReceipt()
        self.fetchUserModel()
        
        self.fetchUserClaims()
    }
    
    private func endListening() {
        receiptReg?.remove()
        userReg?.remove()
        receiptReg = nil
        userReg = nil
    }
    
    private func fetchReceipt() {
        let db = Firestore.firestore()
        receiptReg = db.collection("activities/\(self.getActivityId())/models").document(self.getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let model = try? snapshot?.data(as: Model.self) else {
                print("Failed to decode model or document with that id does not exist.")
                return
            }
            switch model.type {
            case .Bill(let receipt):
                self?.receipt = receipt
            default:
                return
            }
        }
    }
    
    private func fetchUserModel() {
        let db = Firestore.firestore()
        userReg = db.collection("users/\(self.getUserId())/activities/\(self.getActivityId())/models").document(self.getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let userModel = try? snapshot?.data(as: UserBill.self) else {
                print("Failed to decode user mode or document with that id does not exist.")
                return
            }
            self?.userModel = userModel
        }
    }
    
    private func fetchUserClaims() {
        Publishers.CombineLatest($receipt, $userModel)
            .map { [weak self] givenReceipt, givenUser in
                guard let self else { return nil }
                guard let givenReceipt else { return nil }
                guard let givenUser else { return nil }
                let claims = self.generateClaims(givenReceipt: givenReceipt, idClaims: givenUser.claims)
                return Invoice(claims: claims, taxPercentage: givenReceipt.summary.taxPercentage)
            }
            .assign(to: \.userInvoice, on: self)
            .store(in: &cancellables)
    }
    
    private func generateClaims(givenReceipt: Receipt, idClaims: [String: Int]) -> [Claim] {
        let claims = idClaims.compactMap { claim in
            if let sale = givenReceipt.items.first(where: {$0.id == claim.key}) {
                return Claim(sale: sale, quantityClaimed: claim.value)
            }
            return nil
        }
        return claims
    }
    
    func isValid() -> Bool {
        return receipt != nil && userModel != nil
    }
    
    func setItem(itemId: String, quantity: Int) async {
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
        await updateBill(bill: user, sale: item)
    }
    
    func getItem(itemId: String) -> Sale? {
        return receipt?.items.first{ $0.id == itemId}
    }
    
    private func updateBill(bill: UserBill, sale: Sale) async {
        let db = Firestore.firestore()
        let userModelRef = db.collection("users/\(self.getUserId())/activities/\(self.getActivityId())/models").document(self.getModelId())
        do {
            try userModelRef.setData(from: bill)
        } catch {
            print("Failed to store user model")
        }
        guard let receipt else { return }
        if let index = receipt.items.firstIndex(where: {$0.id == sale.id}) {
            var newReceipt = receipt
            newReceipt.items[index] = sale
            let modelRef = db.collection("activities/\(self.getActivityId())/models").document(self.getModelId())
            do {
                try await modelRef.updateData(["type": ExpenseType.Bill(receipt: newReceipt).asDictionary()])
            } catch {
                print("Failed to store model.")
            }
        }
    }
    
    func getModelId() -> String {
        return meta.id
    }
    
    func getActivityId() -> String {
        return meta.activityId
    }
    
    func getUserId() -> String {
        return meta.userId
    }
    
    func getMeta() -> ModelPaths {
        return meta
    }
    
    func isOwner() -> Bool {
        return userModel!.owner
    }

}
