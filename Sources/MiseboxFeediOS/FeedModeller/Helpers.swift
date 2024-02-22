//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.02.2024.
//

import Foundation
import MiseboxiOSGlobal

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
}
extension MiseboxEcosystem.Role {
    func visibleRoles() -> [String] {
        switch self {
        case .miseboxUser:
            return MiseboxEcosystem.Role.allCases.map { $0.doc }
        case .agent:
            return [MiseboxEcosystem.Role.recruiter.doc]
        case .chef:
            // Assuming chefs have specific or no visibility, return an empty array or specific roles
            return []
        case .recruiter:
            return [MiseboxEcosystem.Role.agent.doc]
        default:
            // Handle any other cases if your enum isn't exhaustive
            // If your switch is exhaustive, you may not need this
            return []
        }
    }
}

