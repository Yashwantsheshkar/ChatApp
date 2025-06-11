//
//  APIService.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import Foundation
import Alamofire

class APIService: ObservableObject {
    static let shared = APIService()
    private let baseURL = "http://13.127.170.51:8080/api"
    
    private init() {}
    
    func login(dialCode: String, mobileNumber: Int64) async throws -> User {
        let request = LoginRequest(dialCode: dialCode, mobileNumber: mobileNumber)
        
        let response = try await AF.request(
            "\(baseURL)/v1/user/auth",
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder.default
        ).serializingDecodable(APIResponse<User>.self).value
        
        guard response.status, let user = response.resources?.data else {
            throw APIError.loginFailed(response.message)
        }
        
        return user
    }
    
    func updateProfile(firstName: String, lastName: String, token: String) async throws -> User {
        let request = ProfileUpdateRequest(
            firstName: firstName,
            lastName: lastName,
            referCodeUsed: "SYS1234"
        )
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let response = try await AF.request(
            "\(baseURL)/v2/user/profile",
            method: .put,
            parameters: request,
            encoder: JSONParameterEncoder.default,
            headers: headers
        ).serializingDecodable(APIResponse<User>.self).value
        
        guard response.status, let user = response.resources?.data else {
            throw APIError.profileUpdateFailed(response.message)
        }
        
        return user
    }
    
    func getGroupList(token: String, search: String? = nil) async throws -> [Group] {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        var parameters: [String: Any] = [:]
        if let search = search {
            parameters["search"] = search
        }
        
        let response = try await AF.request(
            "\(baseURL)/v1/group/list",
            method: .get,
            parameters: parameters.isEmpty ? nil : parameters,
            headers: headers
        ).serializingDecodable(APIResponse<[Group]>.self).value
        
        guard response.status, let groups = response.resources?.data else {
            throw APIError.fetchGroupsFailed(response.message)
        }
        
        return groups
    }
    
    func sendMessage(groupId: String, content: String, token: String, file: Data? = nil) async throws {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        try await AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(groupId.data(using: .utf8)!, withName: "group")
            multipartFormData.append(content.data(using: .utf8)!, withName: "content")
            
            if let file = file {
                multipartFormData.append(file, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        }, to: "\(baseURL)/v1/message/send", headers: headers)
        .serializingDecodable(APIResponse<EmptyResponse>.self).value
    }
}

struct EmptyResponse: Codable {}

enum APIError: LocalizedError {
    case loginFailed(String)
    case profileUpdateFailed(String)
    case fetchGroupsFailed(String)
    case sendMessageFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .loginFailed(let message):
            return "Login failed: \(message)"
        case .profileUpdateFailed(let message):
            return "Profile update failed: \(message)"
        case .fetchGroupsFailed(let message):
            return "Failed to fetch groups: \(message)"
        case .sendMessageFailed(let message):
            return "Failed to send message: \(message)"
        }
    }
}
