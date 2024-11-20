//
//  UserCell.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI

struct UserCell: View {
    
    let user: UserBO
    let isFollowing: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            CircularProfileImageView(profileImageUrl: user.profileImageUrl, size: .medium)
                .frame(width: 50, height: 50)
            
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
                
            }) {
                Text(isFollowing ? "Following" : "Follow")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(isFollowing ? .white : .blue)
                    .padding(.vertical, 8)
                    .frame(width: 100)
                    .background(isFollowing ? Color.blue : Color.white)
                    .cornerRadius(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFollowing ? Color.blue : Color(.systemGray4), lineWidth: 1)
                    }
            }
            .padding(.trailing)
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(user: dev.user, isFollowing: false)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
