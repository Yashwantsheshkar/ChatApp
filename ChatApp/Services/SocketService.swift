//
//  SocketService.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import Foundation
import SocketIO

class SocketService: ObservableObject {
    static let shared = SocketService()
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    @Published var isConnected = false
    @Published var totalUnreadCount = 0
    @Published var newMessage: Message?
    @Published var updatedGroup: Group?
    
    private init() {}
    
    func connect(token: String) {
        let url = URL(string: "http://13.127.170.51:8080")!
        
        manager = SocketManager(socketURL: url, config: [
            .log(true),
            .compress,
            .extraHeaders(["Authorization": "Bearer \(token)"])
        ])
        
        socket = manager?.defaultSocket
        
        setupListeners()
        socket?.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
        socket = nil
        manager = nil
        isConnected = false
    }
    
    private func setupListeners() {
        socket?.on(clientEvent: .connect) { [weak self] data, ack in
            DispatchQueue.main.async {
                self?.isConnected = true
            }
        }
        
        socket?.on(clientEvent: .disconnect) { [weak self] data, ack in
            DispatchQueue.main.async {
                self?.isConnected = false
            }
        }
        
        socket?.on("total-unread-count") { [weak self] data, ack in
            if let countData = data.first as? [String: Any],
               let count = countData["unreadCount"] as? Int {
                DispatchQueue.main.async {
                    self?.totalUnreadCount = count
                }
            }
        }
        
        socket?.on("update-chat-list") { [weak self] data, ack in
            if let groupData = data.first as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: groupData)
                    let group = try JSONDecoder().decode(Group.self, from: jsonData)
                    DispatchQueue.main.async {
                        self?.updatedGroup = group
                    }
                } catch {
                    print("Error decoding group update: \(error)")
                }
            }
        }
        
        socket?.on("new-message") { [weak self] data, ack in
            if let messageData = data.first as? [String: Any] {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: messageData)
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let message = try decoder.decode(Message.self, from: jsonData)
                    DispatchQueue.main.async {
                        self?.newMessage = message
                    }
                } catch {
                    print("Error decoding new message: \(error)")
                }
            }
        }
        
        socket?.on("server-error") { data, ack in
            if let errorData = data.first as? [String: Any],
               let message = errorData["message"] as? String {
                print("Server error: \(message)")
            }
        }
        
        socket?.on("input-error") { data, ack in
            if let errorData = data.first as? [String: Any],
               let message = errorData["message"] as? String {
                print("Input error: \(message)")
            }
        }
    }
    
    func joinChat(groupId: String) {
        socket?.emit("join-chat", ["_id": groupId])
    }
    
    func leaveChat(groupId: String) {
        socket?.emit("leave-chat", ["_id": groupId])
    }
}
