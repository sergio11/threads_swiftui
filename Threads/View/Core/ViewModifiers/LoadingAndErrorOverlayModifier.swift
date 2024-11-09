//
//  LoadingAndErrorOverlayModifier.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 9/11/24.
//

import SwiftUI

struct LoadingAndErrorOverlayModifier: ViewModifier {
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    
    var duration: Double = 3.0 // Duration before hiding the snackbar
    
    func body(content: Content) -> some View {
        content
            .overlay {
                ZStack {
                    LoadingView()
                        .opacity(isLoading ? 1 : 0)
                    
                    SnackbarView(message: $errorMessage, duration: duration)
                }
            }
    }
}
