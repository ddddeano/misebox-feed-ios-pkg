//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.02.2024.
//

import Foundation
import FirebaseFirestore
import MiseboxiOSGlobal

extension FeedManager {
    public func loadDummyData(roles: [String]) -> [FeedManager.Post] {
        // Helper to generate different timestamps
        func generateTimestamp(daysBack: Int) -> Date {
            let secondsInDay = 86400
            return Date().addingTimeInterval(TimeInterval(-secondsInDay * daysBack))
        }
        
        // Sample data array
        let sampleData: [(role: MiseboxEcosystem.Role, postType: FeedManager.PostType, title: String, content: String, daysBack: Int)] = [
            (MiseboxEcosystem.Role.chef, .chef(.created), "Chef Alex Joins", "Chef Alex has joined our kitchen brigade.", 1),
            (MiseboxEcosystem.Role.chef, .chef(.deleted), "Chef Bella Departs", "We bid farewell to Chef Bella.", 2),
            (MiseboxEcosystem.Role.miseboxUser, .miseboxUser(.created), "User Charlie Signs Up", "Welcome to our newest Misebox user, Charlie!", 3),
            (MiseboxEcosystem.Role.miseboxUser, .miseboxUser(.deleted), "User Dana Leaves", "User Dana has left our platform.", 4),
            (MiseboxEcosystem.Role.agent, .agent(.created), "Agent Elliot Onboarded", "A warm welcome to Agent Elliot!", 5),
            (MiseboxEcosystem.Role.agent, .agent(.deleted), "Agent Fiona Exits", "Agent Fiona has departed from our agency.", 6),
            (MiseboxEcosystem.Role.recruiter, .recruiter(.created), "Recruiter George Hired", "Excited to announce Recruiter George joining us!", 7),
            (MiseboxEcosystem.Role.recruiter, .recruiter(.deleted), "Recruiter Hannah Leaves", "Farewell to Recruiter Hannah.", 8),
            // Add more as needed...
        ]
        
        // Print roles for debugging
        print("Roles for filtering: \(roles)")
        
        // Filter by roles and map to Post instances
        let generatedPosts = sampleData.filter { data in
            return roles.contains(data.role.doc)
        }.map { data in
            FeedManager.Post(id: UUID().uuidString,
                             role: data.role,
                             postType: data.postType,
                             title: data.title,
                             content: data.content,
                             timestamp: generateTimestamp(daysBack: data.daysBack))
        }
        
        // Print generated posts for debugging
        print("Generated posts: \(generatedPosts)")
        
        return generatedPosts
    }
    public func createDummyDataInFirestore() {
        for _ in 1...10 {
            // Randomly select a role
            guard let randomRole = MiseboxEcosystem.Role.allCases.randomElement() else { continue }
            
            // Generate a random PostType based on the selected role
            let postType = generateRandomPostType(for: randomRole)
            
            let dummyPost = Post(
                id: UUID().uuidString,
                role: randomRole,
                postType: postType,
                title: "Dummy Title",
                content: "Dummy content for Firestore. Role: \(randomRole.doc)",
                timestamp: Date()
            )
            
            Task {
                do {
                    try await firestoreManager.addDocument(toCollection: "posts", withData: dummyPost.toFirestore())
                    print("Dummy post created successfully for role \(randomRole.doc).")
                } catch {
                    print("Error creating dummy post for role \(randomRole.doc): \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Adjusted to use Role instead of an enum
    private func generateRandomPostType(for role: MiseboxEcosystem.Role) -> FeedManager.PostType {
        // Example random selection logic based on the role.doc property
        switch role.doc {
        case "chef":
            let chefTypes: [FeedManager.ChefRolePost] = [.created, .deleted] // Update as necessary
            return .chef(chefTypes.randomElement() ?? .created)
        case "misebox-user":
            let userTypes: [FeedManager.MiseboxUserRolePost] = [.created, .deleted] // Update as necessary
            return .miseboxUser(userTypes.randomElement() ?? .created)
        case "agent":
            let agentTypes: [FeedManager.AgentRolePost] = [.created, .deleted] // Update as necessary
            return .agent(agentTypes.randomElement() ?? .created)
        case "recruiter":
            let recruiterTypes: [FeedManager.RecruiterRolePost] = [.created, .deleted] // Update as necessary
            return .recruiter(recruiterTypes.randomElement() ?? .created)
        default:
            // Fallback for undefined roles
            return .miseboxUser(.created)
        }
    }
}
