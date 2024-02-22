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
                    guard let data = document.data() else {
                        print("Document data is nil for documentID: \(document.documentID)")
                        return nil
                    }
                    print("Document data for \(document.documentID): \(data)")

                    let roleDoc = data["role"] as? String ?? "defaultRole" // Provide a default role if missing
                    print("Role doc: \(roleDoc)")

                    let typeString = data["type"] as? String ?? "defaultType" // Provide a default type if missing
                    print("Type string: \(typeString)")

                    let resolvedRole = MiseboxEcosystem.Role.find(byDoc: roleDoc)

                    guard let postType = FeedManager.PostType.create(role: roleDoc, type: typeString) else {
                        print("Failed to create PostType from role: \(roleDoc) and type: \(typeString)")
                        // If you can't resolve a postType, consider whether you should return nil or provide a default postType
                        return nil
                    }
                    print("PostType: \(postType)")

                    self.id = document.documentID
                    self.role = resolvedRole ?? MiseboxEcosystem.Role.agent
                    self.postType = postType
                    self.title = data["title"] as? String ?? "Default Title"
                    self.content = data["content"] as? String ?? "Default Content"
                    self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()

                    print("Successfully initialized Post for documentID: \(document.documentID) with default values where needed.")
                
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

