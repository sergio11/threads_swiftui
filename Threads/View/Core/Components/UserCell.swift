//
//  UserCell.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI

struct UserCell: View {
    
    let user: UserBO
    var onFollowTapped: (() -> Void)?
    var onProfileImageTapped: (() -> AnyView)?
    
    var body: some View {
        HStack(spacing: 16) {
            
            if let destination = onProfileImageTapped {
                NavigationLink(destination: destination()) {
                    // Profile image and user details
                    ProfileImageView(profileImageUrl: user.profileImageUrl)
                }
            } else {
                ProfileImageView(profileImageUrl: user.profileImageUrl)
            }
            // User Info (Username, Fullname)
            VStack(alignment: .leading, spacing: 4) {
                Text(user.username)
                    .font(.headline) // Larger font for username
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(user.fullname)
                    .font(.subheadline) // Smaller font for fullname
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Follow/Unfollow Button
            Button(action: {
                onFollowTapped?()
            }) {
                Text(user.isFollowedByAuthUser ? "Following" : "Follow")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(user.isFollowedByAuthUser ? .white : .blue)
                    .padding(.vertical, 8)
                    .frame(width: 80)
                    .background(user.isFollowedByAuthUser ? Color.blue : Color.white)
                    .cornerRadius(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(user.isFollowedByAuthUser ? Color.blue : Color(.systemGray4), lineWidth: 1)
                    }
            }
            .padding(.trailing)
        }
        .padding(.horizontal, 4)
        .background(Color.white)
    }
}

private struct ProfileImageView: View {
    
    var profileImageUrl: String?
    
    var body: some View {
        CircularProfileImageView(profileImageUrl: profileImageUrl, size: .medium)
            .frame(width: 50, height: 50)
            .shadow(radius: 1)
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(user: dev.user)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
