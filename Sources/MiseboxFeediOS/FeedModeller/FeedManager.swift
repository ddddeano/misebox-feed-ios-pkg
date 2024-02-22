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
        createDummyDataInFirestore()
    }
    
    deinit {
        listener?.remove()
    }

    public func subscribeToPostsFilteredByRole(completion: @escaping (Result<[Post], Error>) -> Void) {
        let visibleRoles = role.visibleRoles()
        
        // Print the roles we're about to query for debugging
        print("Subscribing to posts filtered by roles: \(visibleRoles)")
        
        self.listener = firestoreManager.listenToPosts(forRoles: visibleRoles) { (result: Result<[Post], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    // Print the count of posts received for debugging
                    print("Received \(posts.count) posts from Firestore in subscribeToPostsFilteredByRole")
                    if posts.isEmpty {
                        print("Note: The posts array is empty. Check if there are posts matching the roles: \(visibleRoles)")
                    }
                    completion(.success(posts))
                case .failure(let error):
                    // Print the error received from Firestore
                    print("Error fetching posts: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
}



