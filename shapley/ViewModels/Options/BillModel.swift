//
//  SplitBillModel.swift
//  shapley
//
//  Created by Michael Campos on 5/26/24.
//

import Foundation
import FirebaseFirestore

class BillModel: ObservableObject {
    @Published var showingNewItemView = false
    private let meta: MetaTrip
    
    init(meta: MetaTrip) {
        self.meta = meta
    }
    
//    private func fetchUserBills() {
//        let db = Firestore.firestore()
//        db.collection("users")
//    }
//    
    
}
