//
//  File.swift
//  
//
//  Created by Daniel Watson on 22.02.2024.
//

import Foundation
extension FeedManager {
    public func loadDummyData() {
        posts = [
            Post(role: .chef, postType: .chef(.created), title: "Chef Alex Joins", content: "Chef Alex has joined our kitchen brigade.", timestamp: Date()),
            Post(role: .chef, postType: .chef(.deleted), title: "Chef Bella Departs", content: "We bid farewell to Chef Bella.", timestamp: Date()),
            Post(role: .miseboxUser, postType: .miseboxUser(.created), title: "User Charlie Signs Up", content: "Welcome to our newest Misebox user, Charlie!", timestamp: Date()),
            Post(role: .miseboxUser, postType: .miseboxUser(.deleted), title: "User Dana Leaves", content: "User Dana has left our platform.", timestamp: Date()),
            Post(role: .agent, postType: .agent(.created), title: "Agent Elliot Onboarded", content: "A warm welcome to Agent Elliot!", timestamp: Date()),
            Post(role: .agent, postType: .agent(.deleted), title: "Agent Fiona Exits", content: "Agent Fiona has departed from our agency.", timestamp: Date()),
            Post(role: .recruiter, postType: .recruiter(.created), title: "Recruiter George Hired", content: "Excited to announce Recruiter George joining us!", timestamp: Date()),
            Post(role: .recruiter, postType: .recruiter(.deleted), title: "Recruiter Hannah Leaves", content: "Farewell to Recruiter Hannah.", timestamp: Date()),
            Post(role: .chef, postType: .chef(.created), title: "Chef Ian's Arrival", content: "Introducing our new chef, Ian!", timestamp: Date()),
            Post(role: .chef, postType: .chef(.deleted), title: "Chef Jade's Departure", content: "Chef Jade has decided to pursue new challenges.", timestamp: Date()),
            Post(role: .miseboxUser, postType: .miseboxUser(.created), title: "User Kyle Joins", content: "A big welcome to Kyle, our new Misebox user!", timestamp: Date()),
            Post(role: .miseboxUser, postType: .miseboxUser(.deleted), title: "User Lila's Account Closed", content: "User Lila has closed their account.", timestamp: Date()),
            Post(role: .agent, postType: .agent(.created), title: "Agent Milo Begins", content: "We're thrilled to have Agent Milo join our team!", timestamp: Date()),
            Post(role: .agent, postType: .agent(.deleted), title: "Agent Nora's Farewell", content: "Today we say goodbye to Agent Nora.", timestamp: Date()),
            Post(role: .recruiter, postType: .recruiter(.created), title: "Recruiter Oliver Onboard", content: "Recruiter Oliver is the newest addition to our team!", timestamp: Date()),
            Post(role: .recruiter, postType: .recruiter(.deleted), title: "Recruiter Piper Departs", content: "Recruiter Piper has left the company.", timestamp: Date()),
            Post(role: .chef, postType: .chef(.created), title: "Chef Quinn's Welcome", content: "Excited to welcome Chef Quinn!", timestamp: Date()),
            Post(role: .chef, postType: .chef(.deleted), title: "Chef Riley's Exit", content: "Chef Riley is moving on to new opportunities.", timestamp: Date()),
            Post(role: .miseboxUser, postType: .miseboxUser(.created), title: "User Sam Signs Up", content: "Thrilled to have Sam join Misebox!", timestamp: Date()),
            Post(role: .miseboxUser, postType: .miseboxUser(.deleted), title: "User Taylor Leaves Misebox", content: "Taylor has decided to leave Misebox.", timestamp: Date())
        ]
    }
}
