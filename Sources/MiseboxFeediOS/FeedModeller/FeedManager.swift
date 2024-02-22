import Foundation
import FirebaseFirestore
import SwiftUI
import MiseboxiOSGlobal
import FirebaseiOSMisebox

@MainActor
public final class FeedManager: ObservableObject {
    @Published public var posts: [Post] = []
    public let role: MiseboxEcosystem.Role
    let firestoreManager = FirestoreManager()

    public var listener: ListenerRegistration?

    public init(role: MiseboxEcosystem.Role) {
        self.role = role
    }

    deinit {
        listener?.remove()
    }

    public func reset() {
        posts = []
    }

    public static func createPost(title: String, content: String, role: MiseboxEcosystem.Role, postType: PostType, timestamp: Date = Date(), additionalData: [String: Any] = [:]) async throws {
    }

    private func subscribeToPostsFilteredByRole() {
        var visibleRoles: [String] = []
        
        // Define visibility based on current role using Role.doc values
        switch role {
        case MiseboxEcosystem.Role.miseboxUser:
            visibleRoles = MiseboxEcosystem.Role.allCases.map { $0.doc }
        case MiseboxEcosystem.Role.agent:
            visibleRoles = [MiseboxEcosystem.Role.recruiter.doc]
        case MiseboxEcosystem.Role.chef:
            // Blank for now, assuming chefs cannot see any posts or only specific types
            visibleRoles = []
        case MiseboxEcosystem.Role.recruiter:
            visibleRoles = [MiseboxEcosystem.Role.agent.doc]
        default:
            // Handle default case if your role matching is exhaustive, this might not be needed
            break
        }

        // Query Firestore based on visibleRoles, assuming 'roleDoc' field in Firestore documents
        listener = firestoreManager.db.collection("posts")
            .whereField("roleDoc", in: visibleRoles)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self?.posts = documents.compactMap { document -> Post? in
                    try? document.data(as: Post.self) // Assuming Post conforms to Decodable or similar
                }
            }
    }
}

extension FeedManager {
    public enum PostType {
        case chef(ChefRolePost)
        case miseboxUser(MiseboxUserRolePost)
        case agent(AgentRolePost)
        case recruiter(RecruiterRolePost)
    }
    
    public enum ChefRolePost: String {
        case created, deleted
    }
    
    public enum MiseboxUserRolePost: String {
        case created, deleted
    }
    
    public enum AgentRolePost: String {
        case created, deleted
    }
    
    public enum RecruiterRolePost: String {
        case created, deleted
    }
    
    public final class Post: Identifiable {
        public var id: String
        public var role: MiseboxEcosystem.Role
        public var postType: PostType
        public var title: String
        public var content: String
        public var timestamp: Date
        
        // Initialize with default UUID
        public init(id: String = UUID().uuidString, role: MiseboxEcosystem.Role, postType: PostType, title: String, content: String, timestamp: Date) {
            self.id = id
            self.role = role
            self.postType = postType
            self.title = title
            self.content = content
            self.timestamp = timestamp
        }
        
    }
}
extension FeedManager.Post {
    @ViewBuilder public func view() -> some View {
        switch postType {
        case .chef(let type):
            switch type {
            case .created:
                FeedManager.ChefCreatedView(role: role, title: title, content: content, timestamp: timestamp)
            case .deleted:
                FeedManager.ChefDeletedView(role: role, title: title, content: content, timestamp: timestamp)
            }
        case .miseboxUser(let type):
            switch type {
            case .created:
                FeedManager.MiseboxUserCreatedView(role: role, title: title, content: content, timestamp: timestamp)
            case.deleted:
                FeedManager.MiseboxDeletedView(role: role, title: title, content: content, timestamp: timestamp)
            }
        case .agent(let type):
            switch type {
            case .created:
                FeedManager.AgentCreatedView(role: role, title: title, content: content, timestamp: timestamp)
            case.deleted:
                FeedManager.AgentDeletedView(role: role, title: title, content: content, timestamp: timestamp)
            }
        case .recruiter(let type):
            switch type {
            case .created:
                FeedManager.RecruiterCreatedView(role: role, title: title, content: content, timestamp: timestamp)
            case.deleted:
                FeedManager.RecruiterDeletedView(role: role, title: title, content: content, timestamp: timestamp)
            }
        }
    }
}

