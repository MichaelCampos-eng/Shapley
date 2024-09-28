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
    @Published var receipt: Receipt?
    @Published var group: [UserDisplayRefs] = []
    @Published var nickName: String?
    
    private var validate: Bool = false
    
    private var receiptReg: ListenerRegistration?
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
        self.fetchReceipt()
        self.fetchGroup()
        self.fetchUserNickName()
    
        self.setIsValid()
    }
    
    func endListening() {
        self.receiptReg?.remove()
        self.validIdsReg?.remove()
        self.nickNameReg?.remove()
        self.receiptReg = nil
        self.validIdsReg = nil
    }
    
    private func fetchReceipt() {
        let db = Firestore.firestore()
        receiptReg = db.collection("activities/\(getActId())/models/").document(getModelId()).addSnapshotListener { [weak self] snapshot, error in
            guard let model = try? snapshot?.data(as: Model.self) else {
                print("Model does not exist.")
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
    
    private func fetchGroup() {
        let db = Firestore.firestore()
        validIdsReg = db.collection("activities").document(getActId()).addSnapshotListener { [weak self] snapshot, error in
            guard let self else { return }
            guard let document = try? snapshot?.data(as: ContentActivity.self) else {
                print("Activity does not exist.")
                return
            }
            self.group = document.validUsers.map{ UserDisplayRefs(paths:  ModelPaths(modelId: self.getModelId(),
                                                                                     userId: $0,
                                                                                     activityId: self.getActId()))}
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
    
    private func setIsValid() {
        Publishers.CombineLatest($nickName, $receipt)
            .map {givenName, givenReceipt in
                return givenName != nil && givenReceipt != nil
            }
            .assign(to: \.validate , on: self)
            .store(in: &cancellables)
    }
    
    private func getModelId() -> String {
        return meta.modelId!
    }
    
    private func getActId() -> String {
        return meta.activityId!
    }
    
    private func getUserId() -> String {
        return meta.userId!
    }
    
    func isValid() -> Bool {
        return validate
    }
}
