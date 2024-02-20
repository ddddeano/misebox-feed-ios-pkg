//
//  FeedManager.swift
//
//
//  Created by Daniel Watson on 20.02.2024.
//

import Foundation

extension FeedManager {
    public final class Post: Identifiable {
        
        public var id: String
        public var title: String
        public var content: String
        public var timestamp: Date
        public var actionType: RoleAction.Type // Referencing the dynamic action type
        
        // Initialize a Post with dynamic action type information
        init(id: String = UUID().uuidString, title: String, content: String, timestamp: Date, actionType: RoleAction.Type) {
            self.id = id
            self.title = title
            self.content = content
            self.timestamp = timestamp
            self.actionType = actionType
        }
        
        // Example: Creating a function to display action name based on the post's action type
        func actionDisplayName() -> String {
            let actionInstance = actionType.init() // This assumes your RoleAction types have an initializer
            return actionInstance.displayName
        }
    }
}
