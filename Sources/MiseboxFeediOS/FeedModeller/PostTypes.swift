//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.02.2024.
//

import Foundation
extension FeedManager {
    public enum ChefRolePost: String, CaseIterable {
        case created, deleted // Add other cases as needed
    }
    
    public enum MiseboxUserRolePost: String, CaseIterable {
        case created, deleted // Add other cases as needed
    }

    public enum AgentRolePost: String, CaseIterable {
        case created, deleted // Add other cases as needed
    }

    public enum RecruiterRolePost: String, CaseIterable {
        case created, deleted // Add other cases as needed
    }
}
