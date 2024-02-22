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
    
    private func createDummyDataInFirestore() {
          let roles: [MiseboxEcosystem.Role] = [.miseboxUser, .agent, .chef, .recruiter] // Example roles
          for index in 1...10 {
              // Randomly select a role for each post
              let randomRole = roles.randomElement() ?? .miseboxUser
              let postType: FeedManager.PostType = index % 2 == 0 ? .chef(.created) : .miseboxUser(.created) // Alternate post types as an example
              
              let dummyPost = Post(
                  id: UUID().uuidString,
                  role: randomRole, // Assign the randomly selected role
                  postType: postType,
                  title: "Dummy Title \(index)",
                  content: "Dummy content for Firestore. Role: \(randomRole)",
                  timestamp: Date()
              )
              
              Task {
                  do {
                      try await firestoreManager.addDocument(toCollection: "posts", withData: dummyPost.toFirestore())
                      print("Dummy post for role \(randomRole) created successfully.")
                  } catch {
                      print("Error creating dummy post for role \(randomRole): \(error.localizedDescription)")
                  }
              }
          }
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



