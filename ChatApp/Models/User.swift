//
//  User.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String?
    let dialCode: String
    let mobileNumber: Int64
    let roles: [Role]
    let interests: [Interest]
    let referCodeUsed: String?
    let onboardingPending: Bool
    let profileImage: ProfileImage?
    let authToken: String?
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, email, dialCode, mobileNumber
        case roles, interests, referCodeUsed, onboardingPending
        case profileImage, authToken, refreshToken
    }
}

struct Role: Codable {
    let id: String
    let role: String
    let label: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case role, label
    }
}

struct Interest: Codable {
    let id: String
    let interestName: String
    let iconUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case interestName, iconUrl
    }
}

struct ProfileImage: Codable {
    let id: String?
    let originalName: String?
    let localFilePath: String?
    let cloudUrl: String?
    let mimeType: String?
    let avatarId: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case originalName, localFilePath, cloudUrl, mimeType, avatarId, url
    }
}
