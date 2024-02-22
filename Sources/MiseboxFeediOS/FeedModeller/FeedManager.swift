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
        // Assuming firestoreManager.listenToPosts is correctly set up to fetch posts based on roles
        self.listener = firestoreManager.listenToPosts(forRoles: visibleRoles) { (result: Result<[Post], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    print("Received posts from Firestore in subscribeToPostsFilteredByRole")
                    completion(.success(posts))
                case .failure(let error):
                    print("Error fetching posts: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
}



