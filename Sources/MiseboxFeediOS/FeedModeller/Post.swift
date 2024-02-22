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
        public var id = ""
        var role: MiseboxEcosystem.Role
        var postType: FeedManager.PostType
        var title: String
        var content: String
        var timestamp: Date

        init(role: MiseboxEcosystem.Role, postType: FeedManager.PostType, title: String, content: String, timestamp: Date) {
            self.role = role
            self.postType = postType
            self.title = title
            self.content = content
            self.timestamp = timestamp
        }
        
        public required init?(document: DocumentSnapshot) {
            guard let data = document.data(),
                  let roleDoc = data["role"] as? String,
                  let typeString = data["type"] as? String,
                  let resolvedRole = MiseboxEcosystem.Role.find(byDoc: roleDoc),
                  let postType = FeedManager.PostType.create(role: roleDoc, type: typeString) else {
                print("Failed to initialize Post from document \(document.documentID)")
                return nil
            }
            
            self.id = document.documentID
            self.role = resolvedRole
            self.postType = postType
            self.title = data["title"] as? String ?? ""
            self.content = data["content"] as? String ?? ""
            self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
            
            print("Successfully initialized Post for documentID: \(document.documentID)")
        }

        public func toFirestore() -> [String: Any] {
            [
                "title": self.title,
                "content": self.content,
                "role": self.role.doc,
                "type": self.postType.serialize(),
                "timestamp": Timestamp(date: self.timestamp)
            ]
        }
    }
}

