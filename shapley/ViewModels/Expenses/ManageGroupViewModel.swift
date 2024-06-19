//
//  ManageGroupViewModel.swift
//  shapley
//
//  Created by Michael Campos on 6/15/24.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseAuth
 
class ManageGroupViewModel: ObservableObject {
    @Published var activity: ContentActivity? = nil
    @Published var validUsers: [String] = []
    @Published var validRemoval: Bool = false
    
    private var activityId: String
    private var cancellables = Set<AnyCancellable>()
    
    init(activityId: String) {
        self.activityId = activityId
        self.fetchActivityContent()
        self.fetchValidUsers()
    }
    
    public func getGroupCode() -> String {
        return self.activity?.groupId ?? "Waiting..."
    }
    
    public func getActivityId() -> String {
        return activityId
    }
    
    private func fetchActivityContent() {
        let db = Firestore.firestore()
        db.collection("activities").document(self.activityId).addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                print("Activity content does not exist")
                return
            }
            self?.activity = try? snapshot.data(as: ContentActivity.self)
        }
    }
    
    private func fetchValidUsers() {
        $activity
            .sink { [weak self] content in
                self?.generateValidUsers(content: content)
            }
            .store(in: &cancellables)
    }
    
    private func generateValidUsers(content: ContentActivity?) {
        guard let content = content else { return }
        self.validUsers = content.validUsers
    }
}
