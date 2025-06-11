//
//  Group.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import Foundation

struct Group: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let file: GroupFile?
    let latestMessage: LatestMessage?
    let unreadCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, description, file, latestMessage, unreadCount
    }
}

struct GroupFile: Codable {
    let originalName: String
    let localFilePath: String
    let mimeType: String
}

struct LatestMessage: Codable {
    let id: String
    let content: String
    let type: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content, type, createdAt
    }
}
