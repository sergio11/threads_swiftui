//
//  BaseViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import Foundation

class BaseViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    internal func onLoading() {
        updateUI { vm in
            vm.isLoading = true
        }
    }
    
    internal func onIddle() {
        updateUI { vm in
            vm.isLoading = false
        }
    }
    
    internal func handleError(error: Error) {
        print(error.localizedDescription)
        updateUI { vm in
            vm.isLoading = false
            vm.errorMessage = error.localizedDescription
        }
    }
    
    
    internal func updateUI<ViewModelType: BaseViewModel>(with updates: @escaping (ViewModelType) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let viewModel = self as? ViewModelType {
                updates(viewModel)
            }
        }
    }
    
    internal func executeAsyncTask<T>(_ task: @escaping () async throws -> T, completion: @escaping (Result<T, Error>) -> Void) {
        Task {
            onLoading()
            do {
                let result = try await task()
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                handleError(error: error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            onIddle()
        }
    }
}
