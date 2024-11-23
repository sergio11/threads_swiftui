//
//  NotificationCell.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 23/11/24.
//

import SwiftUI

struct NotificationCell: View {
    
    let notification: NotificationBO
    var onProfileImageTapped: (() -> AnyView)?
    
    var body: some View {
        HStack(spacing: 16) {
            NotificationTypeIcon(type: notification.type)
            
            if let destination = onProfileImageTapped {
                NavigationLink(destination: destination()) {
                    ProfileImageView(profileImageUrl: notification.byUser.profileImageUrl)
                }
            } else {
                ProfileImageView(profileImageUrl: notification.byUser.profileImageUrl)
            }
            
            NotificationDetails(notification: notification)
            
            Spacer()
        }
        .padding(.horizontal, 4)
        .background(Color.white)
    }
}

private struct NotificationDetails: View {
    
    let notification: NotificationBO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Notification Title
            Text(notification.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            // Notification Message
            Text(notification.message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Timestamp
            Text(notification.timestamp.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
}

/// A helper view to display a user's profile image.
private struct ProfileImageView: View {
    
    var profileImageUrl: String?
    
    var body: some View {
        CircularProfileImageView(profileImageUrl: profileImageUrl, size: .medium)
            .frame(width: 50, height: 50)
            .shadow(radius: 1)
    }
}

/// A helper view to display an icon for a notification type.
private struct NotificationTypeIcon: View {
    
    let type: NotificationType
    
    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundColor(.blue)
            .padding(6)
            .background(Circle().fill(Color.blue.opacity(0.1)))
    }
    
    private var iconName: String {
        switch type {
        case .follow:
            return "person.fill.badge.plus"
        case .like:
            return "heart.fill"
        case .comment:
            return "text.bubble.fill"
        case .repost:
            return "arrow.2.squarepath"
        default:
            return "at"
        }
    }
}


struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCell(notification: dev.notification)
    }
}
