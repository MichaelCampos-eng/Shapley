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
    @Published private var activity: ContentActivity? = nil
    // User ids are fetch from activity
    @Published private var userIds: [String] = []
    
    // Results is the only variable outputed to view
    @Published var results: [String] = []
    // Search query from user in view
    @Published var search: String = ""
    
    // Users depends on changes of userIds
    public var users: [String: String] = [:]
    private var activityId: String
    private var cancellables = Set<AnyCancellable>()
    
    init(activityId: String) {
        self.activityId = activityId
        self.fetchActivityContent()
        self.fetchIds()
        self.fetchSearch()
    }
    
    public func getGroupCode() -> String {
        return self.activity?.groupId ?? "Waiting..."
    }
    
    public func getActivityId() -> String {
        return self.activityId
    }
    
    private func fetchSearch() {
        $search
            .sink { [weak self] _ in
                self?.filterUsers()
            }
            .store(in: &cancellables)
    }
    
    private func filterUsers() {
        if search.isEmpty {
            results = userIds
        } else {
            results = users.filter{ $0.value.contains(search) }.map{ $0.key }
        }
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
    
    private func fetchIds() {
        $activity
            .sink { [weak self] content in
                self?.generateValidUsers(content: content)
                self?.users = [:]
            }
            .store(in: &cancellables)
    }
    
    private func generateValidUsers(content: ContentActivity?) {
        guard let content = content else { return }
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        var validUsers = content.validUsers
        
        if let index = validUsers.firstIndex(of: uId) {
            validUsers.remove(at: index)
            validUsers.insert(uId, at: 0)
            self.userIds = validUsers
            
            // TODO: Might have to move in init function bc results might be buggy
            self.results = validUsers
        }
    }
}
