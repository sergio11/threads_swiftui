//
//  StorageFilesDataSource.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation

/// An enumeration representing possible errors that may occur during storage file operations.
enum StorageFilesError: Error {
    /// Error indicating that the upload operation failed.
    case uploadFailed(message: String)
}

/// An enumeration representing the type of upload operation.
enum UploadType {
    /// Upload operation for profile images.
    case profile
    /// Upload operation for post images.
    case post
}

/// A protocol defining storage file operations.
protocol StorageFilesDataSource {
    /// Uploads the provided image data asynchronously.
    /// - Parameters:
    ///   - imageData: The data of the image to upload.
    ///   - type: The type of upload operation, either `.profile` or `.post`.
    /// - Returns: A string representing the URL of the uploaded image.
    /// - Throws: An error in case of failure.
    func uploadImage(imageData: Data, type: UploadType) async throws -> String
}
