//
//  EventBus.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation
import Combine

class EventBus<Event> {
    private var subject = PassthroughSubject<Event, Never>()
    
    func subscribe() -> AnyPublisher<Event, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    func publish(event: Event) {
        subject.send(event)
    }
}

enum AppEvent {
    case loggedIn
    case loggedOut
}
