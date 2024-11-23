//
//  ActivityViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 23/11/24.
//

import Foundation

import Foundation
import Factory
import Combine

@MainActor
class ActivityViewModel: BaseViewModel {
    
    @Injected(\.fetchNotificationsUseCase) private var fetchNotificationsUseCase: FetchNotificationsUseCase
    @Injected(\.deleteNotificationUseCase) private var deleteNotificationUseCase: DeleteNotificationUseCase
    
    @Published var notifications: [NotificationBO] = []
    
    func fetchData() {
        executeAsyncTask({
            return try await self.fetchNotificationsUseCase.execute()
        }) { [weak self] (result: Result<[NotificationBO], Error>) in
            guard let self = self else { return }
            if case .success(let notifications) = result {
                self.onFetchNotificationsCompleted(notifications: notifications)
            }
        }
    }
    
    func deleteNotification(id: String) {
        executeAsyncTask({
            return try await self.deleteNotificationUseCase.execute(params: DeleteNotificationParams(notificationId: id))
        }) { [weak self] (result: Result<Bool, Error>) in
            guard let self = self else { return }
            if case .success(_) = result {
                self.onDeleteNotificationCompleted(notificationId: id)
            }
        }
    }
    
    private func onDeleteNotificationCompleted(notificationId: String) {
        self.notifications = self.notifications.filter { $0.id != notificationId }
    }
 
    private func onFetchNotificationsCompleted(notifications: [NotificationBO]) {
        self.notifications = notifications
    }
}
