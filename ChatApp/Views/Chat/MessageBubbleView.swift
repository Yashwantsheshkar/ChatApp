//
//  MessageBubbleView.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import SwiftUI
import Kingfisher

struct MessageBubbleView: View {
    let message: Message
    @State private var currentUser = UserDefaults.standard.userData
    
    private var isCurrentUser: Bool {
        message.sender.id == currentUser?.id
    }
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 8) {
                if !isCurrentUser {
                    Text("\(message.sender.firstName) \(message.sender.lastName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let repliedTo = message.repliedTo {
                    RepliedMessageView(repliedMessage: repliedTo)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    if let file = message.file {
                        MessageFileView(file: file)
                    }
                    
                    if !message.content.isEmpty {
                        Text(message.content)
                            .foregroundColor(isCurrentUser ? .white : .primary)
                    }
                    
                    if let event = message.event {
                        EventView(event: event)
                    }
                }
                .padding(12)
                .background(isCurrentUser ? Color.blue : Color(.systemGray5))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray4), lineWidth: isCurrentUser ? 0 : 0.5)
                )
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: isCurrentUser ? .trailing : .leading)
            
            if !isCurrentUser {
                Spacer()
            }
        }
    }
}

struct RepliedMessageView: View {
    let repliedMessage: RepliedMessage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(repliedMessage.sender.firstName) \(repliedMessage.sender.lastName)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            if let file = repliedMessage.file {
                HStack {
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                    Text("Photo")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if !repliedMessage.content.isEmpty {
                Text(repliedMessage.content)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct MessageFileView: View {
    let file: MessageFile
    
    var body: some View {
        if file.mimeType.hasPrefix("image/") {
            KFImage(URL(string: file.localFilePath))
                .placeholder {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                        .frame(height: 200)
                        .overlay(
                            ProgressView()
                        )
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)
                .cornerRadius(8)
        } else {
            HStack {
                Image(systemName: "doc")
                    .foregroundColor(.blue)
                Text(file.originalName)
                    .font(.caption)
                    .lineLimit(1)
                Spacer()
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

struct EventView: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let file = event.file {
                KFImage(URL(string: file.localFilePath))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                    .cornerRadius(8)
            }
            
            Text(event.name)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(event.theme)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "location")
                    .foregroundColor(.blue)
                Text(event.venue)
                    .font(.caption)
            }
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text(formatEventDate(event.startTime))
                    .font(.caption)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func formatEventDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        
        return displayFormatter.string(from: date)
    }
}
