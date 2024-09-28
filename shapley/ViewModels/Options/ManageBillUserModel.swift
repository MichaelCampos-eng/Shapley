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
    @Published var alias: String?
    @Published var invoice: Invoice?
    
    private var claimsReg: ListenerRegistration?
    private var aliasReg: ListenerRegistration?
    
    private let refs: UserDisplayRefs
    private let receipt: Receipt
    
    init(receipt: Receipt, refs: UserDisplayRefs) {
        self.refs = refs
        self.receipt = receipt
        self.beginListening()
    }
    
    func beginListening() {
        self.fetchInvoice()
        self.fetchAlias()
    }
    
    func endListening() {
        claimsReg?.remove()
        aliasReg?.remove()
        claimsReg = nil
        aliasReg = nil
    }
    
    private func fetchAlias() {
        let db = Firestore.firestore()
        aliasReg = db.collection("users/\(getUserId())/activities").document(getActId()).addSnapshotListener { [weak self] snapshot, error in
            guard let userAct = try? snapshot?.data(as: UserActivity.self) else {
                print("User activity does not exist.")
                return
            }
            self?.alias = userAct.tempName
        }
    }
    
    private func fetchInvoice() {
        let db = Firestore.firestore()
        claimsReg = db.collection("users/\(getUserId())/activities/\(getActId())/models").document(getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let self else { return }
            guard let document = try? snapshot?.data(as: UserBill.self) else {
                print("User model does not exist.")
                return
            }
            let claims = self.generateClaims(idClaims: document.claims)
            self.invoice = Invoice(claims: claims, taxPercentage: self.receipt.summary.taxPercentage)
        }
    }
    
    private func generateClaims(idClaims: [String: Int]) -> [Claim] {
        let claimed = idClaims.compactMap { claim in
            if let sale = receipt.items.first(where: {$0.id == claim.key}) {
                return Claim(sale: sale, quantityClaimed: claim.value)
            }
            return nil
        }
        return claimed
    }
    
    func isAvailable() -> Bool {
        return invoice != nil
    }
    
    private func getModelId() -> String {
        return refs.paths.modelId!
    }
    
    private func getActId() -> String {
        return refs.paths.activityId!
    }
    
    private func getUserId() -> String {
        return refs.paths.userId!
    }
    
    func getColor() -> Color {
        return refs.displayColor
    }
}
