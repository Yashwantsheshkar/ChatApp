//
//  Message.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import Foundation

struct Message: Codable, Identifiable {
    let id: String
    let group: String
    let content: String
    let file: MessageFile?
    let repliedTo: RepliedMessage?
    let type: String
    let category: String
    let event: Event?
    let sender: MessageSender
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case group, content, file, repliedTo, type, category, event, sender, createdAt
    }
}

struct MessageFile: Codable {
    let originalName: String
    let localFilePath: String
    let mimeType: String
}

struct RepliedMessage: Codable {
    let id: String
    let sender: MessageSender
    let file: MessageFile?
    let content: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case sender, file, content, type
    }
}

struct Event: Codable {
    let id: String
    let name: String
    let theme: String
    let venue: String
    let startTime: String
    let endTime: String
    let graceTime: String
    let file: EventFile?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, theme, venue, startTime, endTime, graceTime, file
    }
}

struct EventFile: Codable {
    let mimeType: String
    let localFilePath: String
}

struct MessageSender: Codable {
    let id: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName
    }
}
