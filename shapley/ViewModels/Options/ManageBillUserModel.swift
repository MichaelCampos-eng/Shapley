//
//  ManageBillUserModel.swift
//  shapley
//
//  Created by Michael Campos on 7/29/24.
//

import FirebaseFirestore
import Foundation
import Combine
import SwiftUI

class ManageBillUserModel: ObservableObject {
    @Published private var itemsClaimed: [Claim] = []
    @Published private var userNickName: String?
    @Published var userDetails: UserClaims?
    
    private var claimsReg: ListenerRegistration?
    private var nickNameReg: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    private let user: DisplayUser
    private let receipt: Receipt
    
    init(receipt: Receipt, user: DisplayUser) {
        self.user = user
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
            .map { [weak self] nickname, items in
                guard let self else {
                    return nil
                }
                guard let nickname else {
                    return nil
                }
                return UserClaims(alias: nickname, 
                                  claims: items,
                                  taxPercentage: self.receipt.summary.taxPercentage)
            }
            .assign(to: \.userDetails, on: self)
            .store(in: &cancellables)
    }
    
    func isAvailable() -> Bool {
        return userDetails != nil
    }
    
    private func getModelId() -> String {
        return user.pathIds.id
    }
    
    private func getActId() -> String {
        return user.pathIds.activityId
    }
    
    private func getUserId() -> String {
        return user.pathIds.userId
    }
    
    func getColor() -> Color {
        return user.displayColor
    }
}
