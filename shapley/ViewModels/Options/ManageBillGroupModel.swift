//
//  ManageBillGroupModel.swift
//  shapley
//
//  Created by Michael Campos on 7/26/24.
//

import Foundation
import Combine
import FirebaseFirestore

struct BillGroup: Hashable {
    let metaExpense: MetaExpense
    let validUserId: String
}

class ManageBillGroupModel: ObservableObject {
    @Published private var model: Model?
    @Published private var validUserIds: [String] = []
    
    var group: [BillGroup] = []
    
    private var modelReg: ListenerRegistration?
    private var validIdsReg: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    private let meta: MetaExpense
    
    init(meta: MetaExpense) {
        self.meta = meta
        self.beginListening()
    }
    
    func beginListening() {
        self.fetchModel()
        self.fetchIds()
        self.fetchMeta()
    }
    
    func endListening() {
        self.modelReg?.remove()
        self.validIdsReg?.remove()
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
                print("User Model does not exist.")
                return
            }
            self?.validUserIds = document.validUsers
        }
    }
    
    private func fetchMeta() {
        $validUserIds
            .sink { [weak self] val in
                guard let self = self else {
                    return
                }
                self.group = val.map{BillGroup(metaExpense: self.meta, validUserId: $0)}
            }
            .store(in: &cancellables)
    }
    
    private func getModelId() -> String {
        return meta.id
    }
    
    private func getActId() -> String {
        return meta.activityId
    }
}
