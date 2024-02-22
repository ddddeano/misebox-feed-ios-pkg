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
}
