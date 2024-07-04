//
//  SplitBillSetupModel.swift
//  shapley
//
//  Created by Michael Campos on 6/24/24.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation
import Combine

class SplitBillSetupModel: ObservableObject {
    @Published var sharable: Bool = false
    @Published var subtotal: Double = 0.0
    @Published var sales: [Sale] = []
    private let activityId: String
    private var cancellables = Set<AnyCancellable>()
    
    init(id: String) {
        self.activityId = id
        self.fetchSubtotal()
        self.fetchSharable()
    }
    
    public func fetchSubtotal() {
        $sales
            .map { values in
                return values.reduce(0) { $0 + $1.price }
            }
            .assign(to: \.subtotal, on: self)
            .store(in: &cancellables)
    }
    
    public func fetchSharable() {
        $sales
            .map { values in
                values.allSatisfy { $0.isValid() }
            }
            .assign(to: \.sharable, on: self)
            .store(in: &cancellables)
    }
    
    public func updateEntry(sale: Sale) {
        if let index = sales.firstIndex(where: {$0.id == sale.id}) { sales[index] = sale }
    }
    
    public func createNewEntry() {
        sales.append(Sale(id: UUID().uuidString, 
                          name: "",
                          quantity: 0,
                          price: 0.0))
    }
    
    public func deleteEntry(saleId: String) {
        if let index = sales.firstIndex(where: {$0.id == saleId}) { sales.remove(at: index) }
    }
    
    public func shareReceipt(titleName: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.sharable = false
            return
        }
        
        let saveId = UUID().uuidString
        let model = Model(id: saveId, type: "Bill", title: titleName)
        let user = UserBill(id: saveId, owner: true, claims: [])
        
        let db = Firestore.firestore()
        db.collection("activities")
            .document(self.getId())
            .collection("model")
            .document(saveId)
            .setData(model.asDictionary())
        
        db.collection("users")
            .document(userId)
            .collection("activities")
            .document(self.getId())
            .collection("model")
            .document(saveId)
            .setData(user.asDictionary())
        
        for item in self.sales {
            db.collection("activities")
                .document(self.getId())
                .collection("model")
                .document(saveId)
                .collection("items")
                .document(item.id)
                .setData(item.asDictionary())
        }
    }
    
    
    public func getId() -> String {
        return self.activityId
    }
}
