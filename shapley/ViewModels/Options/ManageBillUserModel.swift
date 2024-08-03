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
    @Published private var model: Model?
    @Published private var userActivity: UserActivity?
    @Published private var userModel: UserBill?
    private var userClaims: GroupBill?
    
    private var modelReg: ListenerRegistration?
    private var userActReg: ListenerRegistration?
    private var userModelReg: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    private let meta: BillGroup
    
    init(meta: BillGroup) {
        self.meta = meta
        self.beginListening()
    }
    
    func beginListening() {
        self.fetchModel()
        self.fetchUserAct()
        self.fetchUserModel()
        self.fetchUserClaims()
    }
    
    func endListening() {
        modelReg?.remove()
        userActReg?.remove()
        userModelReg?.remove()
        modelReg = nil
        userActReg = nil
        userModelReg = nil
    }
    
    private func fetchModel() {
        let db = Firestore.firestore()
        modelReg = db.collection("activities/\(getActId())/models").document(getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: Model.self) else {
                print("Model does not exist.")
                return
            }
            self?.model = document
        }
    }
    
    private func fetchUserAct() {
        let db = Firestore.firestore()
        userActReg = db.collection("users/\(getUserId())/activities").document(getActId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: UserActivity.self) else {
                print("User activity does not exist.")
                return
            }
            self?.userActivity = document
        }
     }
    
    private func fetchUserModel() {
        let db = Firestore.firestore()
        userModelReg = db.collection("users/\(getUserId())/activities/\(getActId())/models").document(getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: UserBill.self) else {
                print("User bill does not exist.")
                return
            }
            self?.userModel = document
        }
    }
    
    private func fetchUserClaims() {
        Publishers.CombineLatest3($model, $userModel, $userActivity)
            .map { [weak self] givenModel, givenUserModel, givenUserActivity in
                return self?.generateClaims(mod: givenModel, userMod: givenUserModel, act: givenUserActivity)
            }
            .assign(to: \.userClaims, on: self)
            .store(in: &cancellables)
    }
    
    private func generateClaims(mod: Model?, userMod: UserBill?, act: UserActivity?) -> GroupBill? {
        guard let mod = mod else {
            return nil
        }
        guard let userMod = userMod else {
            return nil
        }
        guard let act = act else {
            return nil
        }
        switch mod.type {
            case .Bill(let receipt):
                let claimed = userMod.claims.compactMap { claim in
                    if let sale = receipt.items.first(where: {$0.id == claim.key}) {
                        return UserClaim(itemName: sale.name, quantityClaimed: claim.value, unitPrice: sale.price / Double(sale.quantity))
                    }
                    return nil
                }
                return GroupBill(id: getUserId(), alias: act.tempName, claims: claimed)
            default:
                return nil
        }
    }
    
    func isAvailable() -> Bool {
        if model != nil, userActivity != nil, userModel != nil {
            return true
        }
        return false
    }
    
    func getUserId() -> String {
        return meta.validUserId
    }
    
    func getCurrentUser() -> String {
        return meta.metaExpense.userId
    }
    
    func getModelId() -> String {
        return meta.metaExpense.id
    }
    
    func getActId() -> String {
        return meta.metaExpense.activityId
    }
    
    func getName() -> String {
        return userClaims!.alias
    }
    
    func getDebt() -> Double {
        let userSubtotal = getSubtotal()
        return userSubtotal + getTax(subtotal: userSubtotal)
    }
    
    private func getSubtotal() -> Double {
        let user = userClaims!
        return user.claims.reduce(0.0) { result, claim in
            result + (claim.unitPrice * Double(claim.quantityClaimed))
        }
    }
    
    private func getTax(subtotal: Double) -> Double {
        switch model!.type {
        case .Bill(let receipt):
            let preTotal = receipt.summary.subtotal
            let tax = receipt.summary.tax
            let taxPer = tax / preTotal
            return subtotal * taxPer
            
        default:
            return 0.0
        }
    }
}
