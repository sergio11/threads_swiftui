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
            switch result {
            case .success(let notifications):
                self.onFetchNotificationsCompleted(notifications: notifications)
            case .failure(let error):
                self.onFetchNotificationsFailed(error: error)
            }
        }
    }
    
    
    private func onFetchNotificationsCompleted(notifications: [NotificationBO]) {
        self.isLoading = false
        self.notifications = notifications
    }
    
    private func onFetchNotificationsFailed(error: Error) {

    }
}
