//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.02.2024.
//

import Foundation
import MiseboxiOSGlobal

extension FeedManager {

        public enum ChefRolePost: String, CaseIterable {
            case created = "chef_created"
            case deleted = "chef_deleted"
        }

        public enum MiseboxUserRolePost: String, CaseIterable {
            case created = "miseboxUser_created"
            case deleted = "miseboxUser_deleted"
        }

        public enum AgentRolePost: String, CaseIterable {
            case created = "agent_created"
            case deleted = "agent_deleted"
        }

        public enum RecruiterRolePost: String, CaseIterable {
            case created = "recruiter_created"
            case deleted = "recruiter_deleted"
        }

    public enum PostType {
        case chef(ChefRolePost)
        case miseboxUser(MiseboxUserRolePost)
        case agent(AgentRolePost)
        case recruiter(RecruiterRolePost)
        
        func serialize() -> String {
               switch self {
               case .chef(let type):
                   return "chef_\(type.rawValue)"
               case .miseboxUser(let type):
                   return "miseboxUser_\(type.rawValue)"
               case .agent(let type):
                   return "agent_\(type.rawValue)"
               case .recruiter(let type):
                   return "recruiter_\(type.rawValue)"
               }
           }
        
        static func create(role: String, type: String) -> PostType? {
                switch role {
                case "chef":
                    guard let chefType = ChefRolePost(rawValue: type) else { return nil }
                    return .chef(chefType)
                case "miseboxUser":
                    guard let userType = MiseboxUserRolePost(rawValue: type) else { return nil }
                    return .miseboxUser(userType)
                case "agent":
                    guard let agentType = AgentRolePost(rawValue: type) else { return nil }
                    return .agent(agentType)
                case "recruiter":
                    guard let recruiterType = RecruiterRolePost(rawValue: type) else { return nil }
                    return .recruiter(recruiterType)
                default:
                    return nil
            }
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

