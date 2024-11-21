//
//  ShareActivityView.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 21/11/24.
//

import SwiftUI
import UIKit

/// A custom view that wraps `UIActivityViewController` from UIKit to present a share sheet.
/// It is used to share content such as text, images, URLs, etc.
/// - `activityItems`: A list of items to be shared (e.g., strings, images, URLs).
/// This view conforms to `UIViewControllerRepresentable` to integrate UIKit components in SwiftUI.
struct ShareActivityView: UIViewControllerRepresentable {
    // The items to share, for example, the thread's caption or other data.
    var activityItems: [Any]
    
    // Creates and returns the `UIActivityViewController` when the view is created.
    func makeUIViewController(context: Context) -> UIActivityViewController {
        // Initialize the share sheet (UIActivityViewController) with the items to share.
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    // Update the UIActivityViewController when SwiftUI's view updates.
    // This is required by the `UIViewControllerRepresentable` protocol, but we do not need to do anything here for this case.
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to update in this case. The activity view controller will automatically update when new data is passed.
    }
}
