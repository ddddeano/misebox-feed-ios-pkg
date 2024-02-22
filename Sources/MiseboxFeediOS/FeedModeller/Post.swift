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
            guard let data = document.data() else {
                print("Document data is nil for documentID: \(document.documentID)")
                return nil
            }
            print("Document data for \(document.documentID): \(data)")
            
            guard let roleDoc = data["role"] as? String else {
                print("Role field missing or not a String for documentID: \(document.documentID)")
                return nil
            }
            print("Role doc: \(roleDoc)")
            
            guard let resolvedRole = MiseboxEcosystem.Role.find(byDoc: roleDoc) else {
                print("Failed to resolve role for documentID: \(document.documentID) with roleDoc: \(roleDoc)")
                return nil
            }
            print("Resolved role: \(resolvedRole.doc)")
            
            guard let postTypeData = data["postType"] as? [String: Any] else {
                print("PostType data missing or not a dictionary for documentID: \(document.documentID)")
                return nil
            }
            print("PostType data: \(postTypeData)")
            
            guard let decodedPostType = FeedManager.PostType.decodeFromFirestore(data: postTypeData) else {
                print("Failed to decode PostType for documentID: \(document.documentID)")
                return nil
            }
            print("Decoded PostType: \(decodedPostType)")
            
            guard let title = data["title"] as? String else {
                print("Title missing or not a String for documentID: \(document.documentID)")
                return nil
            }
            print("Title: \(title)")
            
            guard let content = data["content"] as? String else {
                print("Content missing or not a String for documentID: \(document.documentID)")
                return nil
            }
            print("Content: \(content)")
            
            guard let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
                print("Timestamp missing or not a Timestamp for documentID: \(document.documentID)")
                return nil
            }
            print("Timestamp: \(timestamp)")
            
            self.id = document.documentID
            self.role = resolvedRole
            self.postType = decodedPostType
            self.title = title
            self.content = content
            self.timestamp = timestamp
            
            // Log final initialization success
            print("Successfully initialized Post for documentID: \(document.documentID)")
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
