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
    
    @Published var expensesMeta: [MetaTrip] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let activityId: String
    private let userId: String
    
    private var userData: UserActivity? = nil
    
    init(userId: String, activityId: String) {
        self.activityId = activityId
        self.userId = userId
        self.fetchModelIds()
    }
    
    public func isAdmin() -> Bool {
        return userData!.isAdmin
    }
    
    public func getActivityId() -> String {
        return self.activityId
    }
    
    private func fetchModelIds() {
        let db = Firestore.firestore()
        db.collection("users/\(self.userId)/activities/\(self.activityId)/models").addSnapshotListener  { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No models could be fetched")
                return
            }
            guard let self = self else {
                return
            }
            let metaData = documents.compactMap{ queryDocumentSnapshot -> MetaTrip? in
                
                guard let bill = try? queryDocumentSnapshot.data(as: UserBill.self) else {
                    return nil
                }
                let billId = queryDocumentSnapshot.documentID
                return MetaTrip(id: billId,
                                userId: self.userId,
                                activityId: self.activityId,
                                dateCreated: bill.createdDate)
            }
            self.expensesMeta = metaData.sorted{ $0.dateCreated > $1.dateCreated }
        }
    }
}
