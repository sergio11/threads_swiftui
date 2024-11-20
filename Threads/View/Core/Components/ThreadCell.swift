//
//  ThreadCell.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/7/24.
//

import SwiftUI

struct ThreadCell: View {
    let thread: ThreadBO
    var onLikeTapped: (() -> Void)?
    var onCommentTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    var onRepostTapped: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                CircularProfileImageView(profileImageUrl: thread.user?.profileImageUrl, size: .small)
                    .shadow(radius: 1)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(thread.user?.username ?? "Unknown User")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()

                        Text(thread.timestamp.timeAgoDisplay())
                            .font(.caption)
                            .foregroundColor(Color.gray)
                    }
                    
                    Text(thread.caption)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 8)

                    HStack(spacing: 20) {
                        Button(action: {
                            onLikeTapped?()
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(.black)
                                .font(.body)
                        }

                        Button(action: {
                            onCommentTapped?()
                        }) {
                            Image(systemName: "bubble.right")
                                .foregroundColor(.black)
                                .font(.body)
                        }

                        Button(action: {
                            onRepostTapped?()
                        }) {
                            Image(systemName: "arrow.rectanglepath")
                                .foregroundColor(.black)
                                .font(.body)
                        }

                        Button(action: {
                            onShareTapped?()
                        }) {
                            Image(systemName: "paperplane")
                                .foregroundColor(.black)
                                .font(.body)
                        }
                    }
                    .padding(.top, 8)
                    .foregroundColor(.primary)
                    .font(.system(size: 20))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.white)
        }
        .padding(.vertical, 8)
    }
}

struct ThreadCell_Previews: PreviewProvider {
    static var previews: some View {
        ThreadCell(thread: dev.thread)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
