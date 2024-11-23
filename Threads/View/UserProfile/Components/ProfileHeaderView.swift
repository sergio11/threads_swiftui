//
//  ProfileHeaderView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 20/7/24.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    var user: UserBO?
    
    init(user: UserBO?) {
        self.user = user
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(user?.fullname ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(user?.username ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let bio = user?.bio {
                    Text(bio)
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.bottom, 8)
                }
                
                HStack(spacing: 16) {
                    // Followers
                    if let followers = user?.followers, let userId = user?.id {
                        NavigationLink(destination: ConnectionsView(userId: userId, connectionType: .followers)) {
                            Text("\(followers.count) Followers")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Following
                    if let following = user?.following, let userId = user?.id {
                        NavigationLink(destination: ConnectionsView(userId: userId, connectionType: .following)) {
                            Text("\(following.count) Following")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Show Link if exists
                if let link = user?.link, !link.isEmpty {
                    Text(link)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                        .onTapGesture {
                            if let url = URL(string: link) {
                                UIApplication.shared.open(url)
                            }
                        }
                }
                
                // Profile Private Indicator
                if let isPrivate = user?.isPrivateProfile, isPrivate {
                    Text("This profile is private")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }
            }
            Spacer()
            CircularProfileImageView(profileImageUrl: user?.profileImageUrl, size: .medium)
        }
        .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(user: dev.user)
    }
}
