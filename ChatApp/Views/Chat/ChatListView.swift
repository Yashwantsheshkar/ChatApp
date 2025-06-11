//
//  ChatListView.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var viewModel = ChatListViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.groups) { group in
                NavigationLink(destination: ChatView(group: group)) {
                    ChatListRowView(group: group)
                }
            }
            .refreshable {
                await viewModel.loadGroups()
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout") {
                        authViewModel.logout()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.totalUnreadCount > 0 {
                        Text("\(viewModel.totalUnreadCount)")
                            .font(.caption)
                            .padding(8)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .task {
            await viewModel.loadGroups()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

struct ChatListRowView: View {
    let group: Group
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: group.file?.localFilePath ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.gray)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.headline)
                    .lineLimit(1)
                
                if let latestMessage = group.latestMessage {
                    Text(latestMessage.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if let latestMessage = group.latestMessage {
                    Text(formatDate(latestMessage.createdAt))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if group.unreadCount > 0 {
                    Text("\(group.unreadCount)")
                        .font(.caption)
                        .padding(6)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return "" }
        
        let displayFormatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            displayFormatter.dateFormat = "HH:mm"
        } else {
            displayFormatter.dateFormat = "MM/dd"
        }
        
        return displayFormatter.string(from: date)
    }
}
