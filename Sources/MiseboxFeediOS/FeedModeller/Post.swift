//
//  FeedManager.swift
//
//
//  Created by Daniel Watson on 20.02.2024.
//
import FirebaseiOSMisebox
import MiseboxiOSGlobal
import Foundation
import Firebase

extension FeedManager {
    public final class Post: Identifiable, FeedPost {
        public var id: String
        var role: MiseboxEcosystem.Role
        var postType: FeedManager.PostType
        var title: String
        var content: String
        var timestamp: Date
        
        // Initialize directly for dummy data or specific use cases
        init(id: String = UUID().uuidString, role: MiseboxEcosystem.Role, postType: FeedManager.PostType, title: String, content: String, timestamp: Date) {
            self.id = id
            self.role = role
            self.postType = postType
            self.title = title
            self.content = content
            self.timestamp = timestamp
        }
        
        // Initialize from Firestore DocumentSnapshot
        public required init?(document: DocumentSnapshot) {
            guard let data = document.data(),
                  let roleDoc = data["role"] as? String,
                  let resolvedRole = MiseboxEcosystem.Role.find(byDoc: roleDoc),
                  let postTypeData = data["postType"] as? [String: Any],
                  let decodedPostType = FeedManager.PostType.decodeFromFirestore(data: postTypeData),
                  let title = data["title"] as? String,
                  let content = data["content"] as? String,
                  let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
                return nil
            }
            
            self.id = document.documentID
            self.role = resolvedRole
            self.postType = decodedPostType
            self.title = title
            self.content = content
            self.timestamp = timestamp
        }
        
        // Convert Post to Firestore data format
        public func toFirestore() -> [String: Any] {
            return [
                "title": title,
                "content": content,
                "role": role.doc, // Use the role's document identifier
                "timestamp": Timestamp(date: timestamp),
                "postType": postType.encodeToFirestore()
            ]
        }
    }
}
