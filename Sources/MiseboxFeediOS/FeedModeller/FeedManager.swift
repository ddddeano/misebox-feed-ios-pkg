import Foundation
import FirebaseFirestore
import SwiftUI
import MiseboxiOSGlobal
import FirebaseiOSMisebox

@MainActor
public final class FeedManager: ObservableObject {
    public let role: MiseboxEcosystem.Role
    let firestoreManager = FirestoreManager()
    
    public var listener: ListenerRegistration?
    
    public init(role: MiseboxEcosystem.Role) {
        self.role = role
    }
    
    deinit {
        listener?.remove()
    }
    
    public static func createPost(title: String, content: String, role: MiseboxEcosystem.Role, postType: PostType, timestamp: Date = Date(), additionalData: [String: Any] = [:]) async throws {
    }
    
    public func subscribeToPostsFilteredByRole(completion: @escaping (Result<[Post], Error>) -> Void) {
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
        
        print("Visible roles in subscribeToPostsFilteredByRole: \(visibleRoles)")
        
        // Ensure to adjust the method call according to the new signature
        let listener = firestoreManager.listenToPosts(forRoles: visibleRoles) { (result: Result<[Post], Error>) in
            DispatchQueue.main.async {
                print("Received result in subscribeToPostsFilteredByRole")
                // Generate and return dummy data instead
                let dummyPosts = self.loadDummyData(roles: visibleRoles)
                completion(.success(dummyPosts))
            }
        }
    }

    func createNewPost(post: Post) async throws {
        do {
            try await firestoreManager.addDocument(toCollection: "posts", withData: post.toFirestore())
            print("Post successfully created.")
        } catch {
            print("Error creating post: \(error.localizedDescription)")
            throw error // Propagate the error
        }
    }
}

extension FeedManager {
    public enum PostType {
        case chef(ChefRolePost)
        case miseboxUser(MiseboxUserRolePost)
        case agent(AgentRolePost)
        case recruiter(RecruiterRolePost)
        
        // Example encoder function
        func encodeToFirestore() -> [String: Any] {
            switch self {
            case .chef(let type):
                return ["type": "chef", "subtype": type.rawValue]
            case .miseboxUser(let type):
                return ["type": "miseboxUser", "subtype": type.rawValue]
            case .agent(let type):
                return ["type": "agent", "subtype": type.rawValue]
            case .recruiter(let type):
                return ["type": "recruiter", "subtype": type.rawValue]
            }
        }
        
        // Example decoder function
        static func decodeFromFirestore(data: [String: Any]) -> PostType? {
            guard let type = data["type"] as? String, let subtype = data["subtype"] as? String else { return nil }
            switch type {
            case "chef":
                if let chefType = ChefRolePost(rawValue: subtype) {
                    return .chef(chefType)
                }
            case "miseboxUser":
                if let userType = MiseboxUserRolePost(rawValue: subtype) {
                    return .miseboxUser(userType)
                }
                // Add cases for other types
            default:
                return nil
            }
            return nil
        }
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

