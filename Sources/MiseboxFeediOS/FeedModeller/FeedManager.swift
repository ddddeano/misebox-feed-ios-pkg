//
//  File.swift
//  
//
//  Created by Daniel Watson on 20.02.2024.
//

import Foundation
import GlobalMiseboxiOS
import FirebaseiOSMisebox
import FirebaseFirestore

public protocol RoleAction {
    var displayName: String { get }
    init()
}

@MainActor
public final class FeedManager: ObservableObject {
    
    @Published public var posts: [Post] = []
    public var role: MiseboxEcosystem.Role
    
    let firestoreManager = FirestoreManager()
    
    public var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
        
    public init(role: MiseboxEcosystem.Role) {
        self.role = role
        // Optionally, setup listeners or initial fetch based on role
    }
    
    public func reset() {
        posts = [] // Clears the current list of posts
    }
}

extension FeedManager {
    public func createPost(title: String, content: String, actionType: RoleAction.Type, additionalData: [String: Any] = [:]) async throws {
        // Prepare the data for the new post
        let postData: [String: Any] = [
            "title": title,
            "content": content,
            "timestamp": Date(),
            "type": actionType.init().displayName, // Use the displayName from the RoleAction
            "additionalData": additionalData
        ]
        
        // Assuming FirestoreManager has an async method to add a document
        try await firestoreManager.addDocument(toCollection: "posts", withData: postData)
    }
}

