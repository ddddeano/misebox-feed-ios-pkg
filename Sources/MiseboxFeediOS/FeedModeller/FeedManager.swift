import Foundation
import FirebaseiOSMisebox
import FirebaseFirestore
import GlobalMiseboxiOS
import SwiftUI

public protocol RolePost {
}

extension FeedManager {
    
    enum MiseboxUserRolePost: String, RolePost {
        case created = "Misebox User Created"
        case deleted = "Misebox User Deleted"
    }

    enum ChefRolePost: String, RolePost {
        case created = "Chef Created"
        case deleted = "Chef Deleted"
    }

    enum AgentRolePost: String, RolePost {
        case created = "Agent Created"
        case deleted = "Agent Deleted"

    }
    enum RecruiterRolePost: String, RolePost {
        case created = "Recruiter Created"
        case deleted = "Recruiter Deleted"

    }
}

extension MiseboxEcosystem {
    public enum PostRole {
        case miseboxUser
        case chef
        case agent
        case recruiter

        var rolePosts: [RolePost] {
            switch self {
            case .miseboxUser: return [FeedManager.MiseboxUserRolePost.created, FeedManager.MiseboxUserRolePost.deleted]
            case .chef: return [FeedManager.ChefRolePost.created, FeedManager.ChefRolePost.deleted]
            case .agent: return [FeedManager.AgentRolePost.created, FeedManager.AgentRolePost.deleted]
            case .recruiter: return [FeedManager.RecruiterRolePost.created, FeedManager.RecruiterRolePost.deleted]
            }
        }
    }
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
    }
    
    public func reset() {
        posts = []
    }
    
    public func createPost(title: String, content: String, rolePostType: RolePost.Type, additionalData: [String: Any] = [:]) async throws {
            // The rolePostType parameter is currently not utilized in creating the postData
            // If role-specific post types are to influence postData, their logic needs to be integrated here
            let postData: [String: Any] = [
                "title": title,
                "content": content,
                "timestamp": Date(),
                "roleColor": role.color, // Direct usage of SwiftUI.Color is conceptual; adjust based on your UI/data handling needs
                "additionalData": additionalData
            ]
            
            try await firestoreManager.addDocument(toCollection: "posts", withData: postData)
        }
    struct MiseboxUserPost: RolePost {
        var postTitle: String
        var postColor: Color
    }

    struct ChefPost: RolePost {
        var postTitle: String
        var postColor: Color
    }

    struct AgentPost: RolePost {
        var postTitle: String
        var postColor: Color
    }

    struct RecruiterPost: RolePost {
        var postTitle: String
        var postColor: Color
    }

}

extension FeedManager {
    public final class Post: Identifiable {
        
        public var id: String
        public var title: String
        public var content: String
        public var timestamp: Date
        public var rolePost: RolePost // Assuming a reference or type information for RolePost
        
        // Assuming Role is accessible or passed in some form to indicate which Role this post belongs to
        public let roleColor: Color
        
        public init(id: String = UUID().uuidString, title: String, content: String, timestamp: Date, rolePost: RolePost, roleColor: Color) {
            self.id = id
            self.title = title
            self.content = content
            self.timestamp = timestamp
            self.rolePost = rolePost
            self.roleColor = roleColor // Initialize with the role's color
        }
    }
}
