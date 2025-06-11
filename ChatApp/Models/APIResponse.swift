//
//  APIResponse.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let status: Bool
    let code: Int
    let message: String
    let resources: Resources<T>?
}

struct Resources<T: Codable>: Codable {
    let data: T
}

struct LoginRequest: Codable {
    let dialCode: String
    let mobileNumber: Int64
}

struct ProfileUpdateRequest: Codable {
    let firstName: String
    let lastName: String
    let referCodeUsed: String
}

struct SendMessageRequest: Codable {
    let group: String
    let content: String
}
