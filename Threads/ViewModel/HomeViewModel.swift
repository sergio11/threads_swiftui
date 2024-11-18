//
//  HomeViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 18/11/24.
//

import Foundation
import Factory
import Combine

class HomeViewModel: BaseViewModel {
    
    @Published var selectedTab = 0
    @Published var showCreateThreadView = false
    
}
