//
//  TripExpensesModel.swift
//  shapley
//
//  Created by Michael Campos on 6/2/24.
//

import FirebaseFirestore
import Foundation
import Combine 
  
class ExpensesViewModel: ObservableObject {
    @Published var showingNewTrip: Bool = false
    @Published var showingManageGroup: Bool = false
    
    @Published var expensesMeta: [MetaExpense] = []
    @Published var titleName: String = "Loading..."
    
    private var expenseReg: ListenerRegistration?
    private var nameReg: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    private let activityId: String
    private let userId: String
    
    private var userData: UserActivity? = nil
    
    init(userId: String, activityId: String) {
        self.activityId = activityId
        self.userId = userId
        self.beginListening()
    }
    
    func beginListening() {
        fetchModelIds()
        fetchActivityName()
    }
    
    func endListening() {
        expenseReg?.remove()
        nameReg?.remove()
        expenseReg = nil
        nameReg = nil
    }
    
    func isAdmin() -> Bool {
        return userData!.isAdmin
    }
    
    func getActivityId() -> String {
        return self.activityId
    }
    
    private func fetchActivityName() {
        let db = Firestore.firestore()
        nameReg = db.collection("activities").document(self.activityId).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: ContentActivity.self) else {
                print("Unable to get activity document.")
                return
            }
            self?.titleName = document.title
        }
    }
    
    private func fetchModelIds() {
        let db = Firestore.firestore()
        expenseReg = db.collection("activities/\(self.activityId)/models").addSnapshotListener  { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No models could be fetched")
                return
            }
            guard let self = self else {
                return
            }
            let metaData = documents.compactMap{ queryDocumentSnapshot -> MetaExpense? in
                guard let model = try? queryDocumentSnapshot.data(as: Model.self) else {
                    print("Unable to decode.")
                    return nil
                }
                let modelId = queryDocumentSnapshot.documentID
                return MetaExpense(id: modelId,
                                   userId: self.userId,
                                   activityId: self.activityId,
                                   type: model.type,
                                   dateCreated: model.createdDate)
            }.sorted{ $0.dateCreated > $1.dateCreated }
            self.expensesMeta = metaData
        }
    }
}
