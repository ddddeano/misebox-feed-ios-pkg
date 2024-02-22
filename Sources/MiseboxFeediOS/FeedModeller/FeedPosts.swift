//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 22.02.2024.
//

import SwiftUI
import GlobalMiseboxiOS

extension FeedManager {
    
    
    struct ChefCreatedView: View {
        var role: MiseboxEcosystem.Role
        var title: String
        var content: String
        var timestamp: Date
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(content)
                Text(timestamp, style: .date).font(.caption)
            }
            .padding()
            .background(role.color.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    struct MiseboxUserCreatedView: View {
        var role: MiseboxEcosystem.Role
        var title: String
        var content: String
        var timestamp: Date
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(content)
                Text(timestamp, style: .date).font(.caption)
            }
            .padding()
            .background(role.color.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    // Template for AgentCreatedView and others
    struct AgentCreatedView: View {
        var role: MiseboxEcosystem.Role
        var title: String
        var content: String
        var timestamp: Date
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(content)
                Text(timestamp, style: .date).font(.caption)
            }
            .padding()
            .background(role.color.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    struct ChefDeletedView: View {
        var role: MiseboxEcosystem.Role
        var title: String
        var content: String
        var timestamp: Date
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(content)
                Text(timestamp, style: .date).font(.caption)
            }
            .padding()
            .background(role.color.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    struct MiseboxDeletedView: View {
        var role: MiseboxEcosystem.Role
        var title: String
        var content: String
        var timestamp: Date
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(content)
                Text(timestamp, style: .date).font(.caption)
            }
            .padding()
            .background(role.color.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    struct AgentDeletedView: View {
        var role: MiseboxEcosystem.Role
        var title: String
        var content: String
        var timestamp: Date
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(content)
                Text(timestamp, style: .date).font(.caption)
            }
            .padding()
            .background(role.color.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    struct RecruiterCreatedView: View {
        var role: MiseboxEcosystem.Role
        var title: String
        var content: String
        var timestamp: Date
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(content)
                Text(timestamp, style: .date).font(.caption)
            }
            .padding()
            .background(role.color.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    struct RecruiterDeletedView: View {
        var role: MiseboxEcosystem.Role
        var title: String
        var content: String
        var timestamp: Date
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(content)
                Text(timestamp, style: .date).font(.caption)
            }
            .padding()
            .background(role.color.opacity(0.2))
            .cornerRadius(8)
        }
    }
}
