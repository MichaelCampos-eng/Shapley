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
    
    @Published var title: String = "Loading..."
    @Published var expensesMeta: [MetaExpense] = []
    
    private var expenseReg: ListenerRegistration?
    private var nameReg: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    private let meta: ModelPaths
    private var userData: UserActivity? = nil
    
    init(paths: ModelPaths) {
        self.meta = paths
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
    
    private func fetchActivityName() {
        let db = Firestore.firestore()
        nameReg = db.collection("activities").document(getActId()).addSnapshotListener { [weak self] snapshot, error in
            guard let document = try? snapshot?.data(as: ContentActivity.self) else {
                print("Unable to get activity document.")
                return
            }
            self?.title = document.title
        }
    }
    
    private func fetchModelIds() {
        let db = Firestore.firestore()
        expenseReg = db.collection("activities/\(getActId())/models").addSnapshotListener  { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No models could be fetched")
                return
            }
            guard let self = self else {
                return
            }
            let metaData = documents.compactMap { queryDocumentSnapshot -> MetaExpense? in
                guard let model = try? queryDocumentSnapshot.data(as: Model.self) else {
                    print("Unable to decode.")
                    return nil
                }
                var paths = self.getMeta()
                paths.modelId = queryDocumentSnapshot.documentID
                return MetaExpense(paths: paths,
                                   type: model.type,
                                   createdDate: model.createdDate)
            }.sorted{ $0.createdDate > $1.createdDate }
            self.expensesMeta = metaData
        }
    }
    
    func getActId() -> String {
        return meta.activityId!
    }
    
    func getMeta() -> ModelPaths {
        return meta
    }
}
