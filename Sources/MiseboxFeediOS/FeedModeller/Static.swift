//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.02.2024.
//

import Foundation
import FirebaseiOSMisebox

extension FeedManager {
    static func createNewPost(post: Post, firestoreManager: FirestoreManager) async throws {
        do {
            try await firestoreManager.addDocument(toCollection: "posts", withData: post.toFirestore())
            print("Post successfully created.")
        } catch {
            print("Error creating post: \(error.localizedDescription)")
            throw error // Propagate the error
        }
    }
}
