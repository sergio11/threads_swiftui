//
//  EditProfileViewModel.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 21/7/24.
//

import PhotosUI
import SwiftUI
import Factory
import Combine

class EditProfileViewModel: BaseUserViewModel {
    
    @Injected(\.updateUserUseCase) private var updateUserUseCase: UpdateUserUseCase
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task { await loadImage() }
        }
    }
    @Published var bio = ""
    @Published var link = ""
    @Published var isPrivateProfile = false
    @Published var profileImage: Image?
    @Published var userProfileUpdated: Bool = false
    
    private var uiImageData: Data?
    
    func onUpdateProfile() {
        executeAsyncTask({
            return try await self.updateUserUseCase.execute(params: UpdateUserParams(fullname: self.authUserFullName, bio: self.bio, link: self.link, selectedImage: self.uiImageData, isPrivateProfile: self.isPrivateProfile))
        }) { [weak self] (result: Result<UserBO, Error>) in
            guard let self = self else { return }
            if case .success(let user) = result {
                self.onUserUpdated(user: user)
            }
        }
    }
    
    override func onCurrentUserLoaded(user: UserBO) {
        super.onCurrentUserLoaded(user: user)
        self.bio = user.bio ?? ""
        self.link = user.link ?? ""
        self.isPrivateProfile = user.isPrivateProfile
    }

    @MainActor
    private func loadImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImageData = data
        self.profileImage = Image(uiImage: uiImage)
    }
    
    private func onUserUpdated(user: UserBO) {
        self.onCurrentUserLoaded(user: user)
        self.userProfileUpdated = true
    }
}
