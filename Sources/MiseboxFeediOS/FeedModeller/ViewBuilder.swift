//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.02.2024.
//

import Foundation
import SwiftUI

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
