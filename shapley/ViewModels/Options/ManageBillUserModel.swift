//
//  ManageBillUserModel.swift
//  shapley
//
//  Created by Michael Campos on 7/29/24.
//

import FirebaseFirestore
import Foundation
import Combine

class ManageBillUserModel: ObservableObject {
    @Published private var itemsClaimed: [Claim] = []
    @Published private var userNickName: String?
    private var userDetails: UserClaims?
    
    private var claimsReg: ListenerRegistration?
    private var nickNameReg: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    private let receipt: Receipt
    private let pathIds: ModelPaths
    
    init(receipt: Receipt, refPaths: ModelPaths) {
        self.pathIds = refPaths
        self.receipt = receipt
        self.beginListening()
    }
    
    func beginListening() {
        self.fetchClaims()
        self.fetchNickName()
        
        self.fetchUserDetails()
    }
    
    func endListening() {
        claimsReg?.remove()
        nickNameReg?.remove()
        claimsReg = nil
        nickNameReg = nil
    }
    
    private func fetchNickName() {
        let db = Firestore.firestore()
        nickNameReg = db.collection("users/\(getUserId())/activities").document(getActId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: UserActivity.self) else {
                print("User activity does not exist.")
                return
            }
            self?.userNickName = document.tempName
        }
    }
    
    private func fetchClaims() {
        let db = Firestore.firestore()
        claimsReg = db.collection("users/\(getUserId())/activities/\(getActId())/models").document(getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: UserBill.self) else {
                print("User model does not exist.")
                return
            }
            guard let self else {
                return
            }
            self.itemsClaimed = self.generateClaims(idClaims: document.claims)
        }
    }
    
    private func generateClaims(idClaims: [String: Int]) -> [Claim] {
        let claimed = idClaims.compactMap { claim in
            if let sale = receipt.items.first(where: {$0.id == claim.key}) {
                return Claim(itemName: sale.name, 
                             quantityClaimed: claim.value,
                             unitPrice: sale.price / Double(sale.quantity))
            }
            return nil
        }
        return claimed
    }
    
    private func fetchUserDetails() {
        Publishers.CombineLatest($userNickName, $itemsClaimed)
            .map { nickname, items in
                guard let name = nickname else {
                    return nil
                }
                return UserClaims(alias: name, claims: items)
            }
            .assign(to: \.userDetails, on: self)
            .store(in: &cancellables)
    }
    
    func isAvailable() -> Bool {
        return userNickName != nil && userDetails != nil
    }
    
    private func getModelId() -> String {
        return pathIds.id
    }
    
    private func getActId() -> String {
        return pathIds.activityId
    }
    
    private func getUserId() -> String {
        return pathIds.userId
    }
    
    func getItems() -> [Claim] {
        return userDetails!.claims
    }
    
    func getAlias() -> String {
        return userDetails!.alias
    }
    
    func getDebt() -> Double {
        let userSubtotal = getSubtotal()
        return userSubtotal + getTax()
    }
    
    func getSubtotal() -> Double {
        let user = userDetails!
        return user.claims.reduce(0.0) { result, claim in
            result + (claim.unitPrice * Double(claim.quantityClaimed))
        }
    }
    
    func getTax() -> Double {
        let preTotal = receipt.summary.subtotal
        let tax = receipt.summary.tax
        let taxPer = tax / preTotal
        return getSubtotal() * taxPer
    }
}
