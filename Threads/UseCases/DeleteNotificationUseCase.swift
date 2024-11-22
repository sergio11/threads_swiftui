//
//  DeleteNotificationUseCase.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 22/11/24.
//

import Foundation

enum DeleteNotificationError: Error {
    case deleteFailed
}

struct DeleteNotificationParams {
    var notificationId: String
}

/// An entity responsible for deleting a notification.
struct DeleteNotificationUseCase {
    let notificationsRepository: NotificationsRepository
    
    /// Executes the delete operation for a notification asynchronously.
    /// - Parameter params: include the ID of the notification to be deleted.
    /// - Returns: A boolean indicating whether the delete operation was successful.
    /// - Throws: An error if the delete operation fails.
    func execute(params: DeleteNotificationParams) async throws -> Bool {
        do {
            let success = try await notificationsRepository.deleteNotification(notificationId: params.notificationId)
            if !success {
                throw DeleteNotificationError.deleteFailed
            }
            return success
        } catch {
            throw DeleteNotificationError.deleteFailed
        }
    }
}
