//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let group: Group
    private let apiService = APIService.shared
    private let socketService = SocketService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(group: Group) {
        self.group = group
        setupSocketListeners()
        joinChat()
    }
    
    deinit {
        // Call leaveChat synchronously without await
        Task {
            await leaveChat()
        }
    }
    
    private func setupSocketListeners() {
        socketService.$newMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newMessage in
                if newMessage.group == self?.group.id {
                    self?.messages.append(newMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func joinChat() {
        socketService.joinChat(groupId: group.id)
    }
    
    private func leaveChat() async {
        socketService.leaveChat(groupId: group.id)
    }
    
    func sendMessage() async {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let token = UserDefaults.standard.authToken else { return }
        
        let content = messageText
        messageText = ""
        
        do {
            try await apiService.sendMessage(
                groupId: group.id,
                content: content,
                token: token
            )
        } catch {
            errorMessage = error.localizedDescription
            messageText = content // Restore message on error
        }
    }
}
