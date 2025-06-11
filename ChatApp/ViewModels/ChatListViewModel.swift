//
//  ChatListViewModel.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import Foundation
import Combine

@MainActor
class ChatListViewModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var totalUnreadCount = 0
    
    private let apiService = APIService.shared
    private let socketService = SocketService.shared
    
    init() {
        setupSocketListeners()
    }
    
    func loadGroups() async {
        guard let token = UserDefaults.standard.authToken else { return }
        
        isLoading = true
        do {
            let fetchedGroups = try await apiService.getGroupList(token: token)
            groups = fetchedGroups
            
            // Connect to socket after loading groups
            socketService.connect(token: token)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    private func setupSocketListeners() {
        // Listen for total unread count updates
        socketService.$totalUnreadCount
            .receive(on: DispatchQueue.main)
            .assign(to: &$totalUnreadCount)
        
        // Listen for group updates
        socketService.$updatedGroup
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedGroup in
                self?.updateGroup(updatedGroup)
            }
            .store(in: &cancellables)
    }
    
    private func updateGroup(_ updatedGroup: Group) {
        if let index = groups.firstIndex(where: { $0.id == updatedGroup.id }) {
            groups[index] = updatedGroup
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
}
