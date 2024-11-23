//
//  NotificationCell.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 23/11/24.
//

import SwiftUI
import SwipeActions

struct NotificationCell: View {
    
    let notification: NotificationBO
    var onProfileImageTapped: (() -> AnyView)?
    var onDeleteNotification: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 16) {
            
            if let destination = onProfileImageTapped {
                NavigationLink(destination: destination()) {
                    ProfileImageView(profileImageUrl: notification.byUser.profileImageUrl)
                }
            } else {
                ProfileImageView(profileImageUrl: notification.byUser.profileImageUrl)
            }
            
            NotificationDetails(notification: notification)
            
            Spacer()
            
            VStack {
                // Notification Type Icon
                NotificationTypeIcon(type: notification.type)
                    .frame(width: 20, height: 20)
                    .padding([.top, .trailing], 8)
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white)
        .addSwipeAction(edge: .trailing) {
            Button {
                onDeleteNotification?()
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
            .frame(width: 120, height: 100, alignment: .center)
            .contentShape(Rectangle())
            .background(Color.red)
        }
        
    }
}

private struct NotificationDetails: View {
    
    let notification: NotificationBO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Notification Title
            Text(notification.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            // Notification Message
            Text(notification.message)
                .font(.footnote)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Timestamp
            Text(notification.timestamp.timeAgoDisplay())
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
            .frame(width: 48, height: 48)
            .shadow(radius: 2)
    }
}

/// A helper view to display an icon for a notification type.
private struct NotificationTypeIcon: View {
    
    let type: NotificationType
    
    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
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
        }
    }
}


struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCell(notification: dev.notification)
    }
}
