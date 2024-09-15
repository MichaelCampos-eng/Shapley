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
    @Published var nickName: String?
    
    @Published var receipt: Receipt?
    @Published var group: [DisplayUser] = []
    
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
        self.fetchGroup()
        self.fetchUserNickName()
    
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
    
    private func fetchGroup() {
        let db = Firestore.firestore()
        validIdsReg = db.collection("activities").document(getActId()).addSnapshotListener { [weak self] snapshot, error in
            guard let self else {
                return
            }
            guard let document = try? snapshot?.data(as: ContentActivity.self) else {
                print("Activity does not exist.")
                return
            }
            self.group = document.validUsers.map{ DisplayUser(pathIds:  ModelPaths(id: self.getModelId(),
                                                                                    userId: $0,
                                                                                    activityId: self.getActId()))
                           }
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
    
    private func fetchReceipt() {
        $model
            .sink { [weak self] givenModel in
                guard let self = self else {
                    return
                }
                switch givenModel?.type {
                case .Bill(let receipt):
                    self.receipt = receipt
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
    
    private func setIsValid() {
        Publishers.CombineLatest3($model, $nickName, $receipt)
            .map { givenModel, givenName, givenReceipt in
                return givenModel != nil && givenName != nil && givenReceipt != nil
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
}
