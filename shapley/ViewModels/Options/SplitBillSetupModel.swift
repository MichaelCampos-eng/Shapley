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
    @Published var salesValid: Bool = false
    @Published var receipt: GeneralReceipt = GeneralReceipt(id: UUID().uuidString,
                                                            subtotal: 0.0,
                                                            tax: 0.0)
    @Published var sales: [Sale] = []
    private let activityId: String
    private var cancellables = Set<AnyCancellable>()
    private let entrySubject = PassthroughSubject<Sale, Never>()
    private let receiptSubject = PassthroughSubject<GeneralReceipt, Never>()
    
    init(id: String) {
        self.activityId = id
        self.fetchSubtotal()
        self.fetchSharable()
        self.setupEntryListener()
        self.setupReceiptListener()
    }
    
    public func isSharable(titleName: String) -> Bool {
        return salesValid && !titleName.isEmpty
    }
    
    private func setupReceiptListener() {
        receiptSubject
            .debounce(for: .milliseconds(100), scheduler: RunLoop.current)
            .sink { [weak self] generalReceipt in
                print("Updating receipt")
                self?.updateReceipt(receipt: generalReceipt)
            }
            .store(in: &cancellables)
    }
    
    private func setupEntryListener() {
        entrySubject
            .sink { [weak self] sale in
                print("Sale: \(sale)")
                self?.updateEntry(sale: sale)
            }
            .store(in: &cancellables)
    }
    
    public func fetchSubtotal() {
            $sales
                .sink { [weak self] values in
                    guard let self = self else {
                        return
                    }
                    
                    var total = values.reduce(0) { $0 + $1.price }
                    total = (total * 100.0).rounded() / 100.0
                    var newReceipt = self.receipt
                    newReceipt.changeSubtotal(total)
                    print(newReceipt)
                    if self.isValidReceipt(newReceipt) {
                        self.submitReceipt(newReceipt)
                        print("Sales Change")
                    }
                }
                .store(in: &cancellables)
    }
    
    public func fetchSharable() {
        $sales
            .map { values in
                values.allSatisfy { $0.isValid() } && values.count != 0
            }
            .assign(to: \.salesValid, on: self)
            .store(in: &cancellables)
    }
    
    public func submitReceipt(_ newReceipt: GeneralReceipt) {
        receiptSubject.send(newReceipt)
    }
    
    private func updateReceipt(receipt: GeneralReceipt) {
        self.receipt = receipt
    }
    
    public func submitEntry(_ sale: Sale) {
        entrySubject.send(sale)
    }
    
    public func isValidReceipt(_ receipt: GeneralReceipt) -> Bool {
        if self.receipt != receipt {
            return true
        }
        return false
    }
    
    public func isValidEntry(_ sale: Sale) -> Bool {
        if let index = sales.firstIndex(where: {$0.id == sale.id}) {
            let currentSale = sales[index]
            if currentSale != sale {
                return true
            }
        }
        return false
    }
    
    private func updateEntry(sale: Sale) {
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
            self.salesValid = false
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
        
        db.collection("activities")
            .document(self.getId())
            .collection("model")
            .document(saveId)
            .collection("meta")
            .document("general")
            .setData(self.receipt.asDictionary())
            
        
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
                .collection("meta")
                .document("general")
                .collection("items")
                .document(item.id)
                .setData(item.asDictionary())
        }
    }
    
    
    public func getId() -> String {
        return self.activityId
    }
}
