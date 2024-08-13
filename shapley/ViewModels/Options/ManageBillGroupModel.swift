//
//  ManageBillGroupModel.swift
//  shapley
//
//  Created by Michael Campos on 7/26/24.
//

import Foundation
import Combine
import FirebaseFirestore
 
class ManageBillGroupModel: ObservableObject {
    @Published private var model: Model?
    @Published private var validUserIds: [String] = []
    @Published private var nickName: String?
    
    private var group: BillGroup?
    private var items: [Sale] = []
    private var missingAmount: Double?
    private var total: Double?
    private var validate: Bool = false
    
    private var modelReg: ListenerRegistration?
    private var validIdsReg: ListenerRegistration?
    private var nickNameReg: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    // For current user
    private let meta: ModelPaths
    
    init(meta: ModelPaths) {
        self.meta = meta
        self.beginListening()
    }
    
    func beginListening() {
        self.fetchModel()
        self.fetchIds()
        self.fetchUserNickName()
        
        self.fetchMeta()
        self.fetchReceipt()
        self.setIsValid()
    }
    
    func endListening() {
        self.modelReg?.remove()
        self.validIdsReg?.remove()
        self.nickNameReg?.remove()
        self.modelReg = nil
        self.validIdsReg = nil
    }
    
    private func fetchModel() {
        let db = Firestore.firestore()
        modelReg = db.collection("activities/\(getActId())/models/").document(getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: Model.self) else {
                print("Model does not exist.")
                return
            }
            self?.model = document
        }
    }
    
    private func fetchIds() {
        let db = Firestore.firestore()
        validIdsReg = db.collection("activities").document(getActId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: ContentActivity.self) else {
                print("Activity does not exist.")
                return
            }
            self?.validUserIds = document.validUsers
        }
    }
    
    private func fetchUserNickName() {
        let db = Firestore.firestore()
        nickNameReg = db.collection("users/\(getUserId())/activities").document(getActId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: UserActivity.self) else {
                print("User activity does not exist.")
                return
            }
            self?.nickName = document.tempName
        }
    }
    
    private func fetchMeta() {
        $validUserIds
            .sink { [weak self] newUserIds in
                guard let self = self else {
                    return
                }
                self.group = BillGroup(receipt: getReciept(), 
                                       validUsers: newUserIds.map{ModelPaths(id: self.getModelId(),
                                                                           userId: $0,
                                                                           activityId: self.getActId())})
            }
            .store(in: &cancellables)
    }
    
    private func fetchReceipt() {
        $model
            .sink { [weak self] val in
                guard let self = self else {
                    return
                }
                switch(val?.type) {
                case .Bill(let receipt):
                    self.items = receipt.items
                    self.total = receipt.summary.total
                    self.missingAmount = receipt.items.reduce(0.0) { (result, item) in
                        result + (Double(item.available) * item.price)}
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
    
    private func setIsValid() {
        Publishers.CombineLatest($model, $nickName)
            .map { givenModel, givenName in
                givenModel != nil && givenName != nil
            }
            .assign(to: \.validate , on: self)
            .store(in: &cancellables)
    }
    
    private func getModelId() -> String {
        return meta.id
    }
    
    private func getActId() -> String {
        return meta.activityId
    }
    
    private func getUserId() -> String {
        return meta.userId
    }
    
    func isValid() -> Bool {
        return validate
    }
    
    func getNickname() -> String {
        return nickName!
    }
    
    func getMissingAmount() -> Double {
        return missingAmount!
    }
    
    func getTotal() -> Double {
        return total!
    }
    
    func getSales() -> [Sale] {
        return self.items
    }
    
    func getGroup() -> BillGroup {
        return self.group!
    }
    
    func getMeta() -> ModelPaths {
        return self.meta
    }
    
    private func getReciept() -> Receipt {
        switch model?.type {
        case .Bill(let reciept):
            return reciept
        default:
            return Receipt(summary: GeneralReceipt(subtotal: 0.0, tax: 0.0), items: [])
        }
    }
}
