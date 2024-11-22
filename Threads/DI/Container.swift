//
//  Container.swift
//  Threads
//
//  Created by Sergio Sánchez Sánchez on 8/11/24.
//

import Foundation
import Factory


extension Container {
    
    var storageDataSource: Factory<StorageFilesDataSource> {
        self { FirestoreStorageFilesDataSourceImpl() }.singleton
    }
}

extension Container {
    
    var threadMapper: Factory<ThreadMapper> {
        self { ThreadMapper(userMapper: self.userMapper()) }.singleton
    }
    
    var createThreadMapper: Factory<CreateThreadMapper> {
        self { CreateThreadMapper() }.singleton
    }
    
    var threadsDataSource: Factory<ThreadsDataSource> {
        self { FirestoreThreadsDataSourceImpl() }.singleton
    }
    
    var threadsRepository: Factory<ThreadsRepository> {
        self { ThreadsRepositoryImpl(
            threadsDataSource: self.threadsDataSource(), threadMapper: self.threadMapper(), createThreadMapper: self.createThreadMapper(), userDataSource: self.userDataSource(), authenticationRepository: self.authenticationRepository()) }.singleton
    }
    
    var fetchThreadsUseCase: Factory<FetchThreadsUseCase> {
        self { FetchThreadsUseCase(threadsRepository: self.threadsRepository(), authRepository: self.authenticationRepository()) }
    }
    
    var fetchOwnThreadsUseCase: Factory<FetchOwnThreadsUseCase> {
        self { FetchOwnThreadsUseCase(threadsRepository: self.threadsRepository(), authRepository: self.authenticationRepository()) }
    }
    
    var createThreadUseCase: Factory<CreateThreadUseCase> {
        self { CreateThreadUseCase(authRepository: self.authenticationRepository(), threadsRepository: self.threadsRepository()) }
    }
    
    var fetchThreadsByUserUseCase: Factory<FetchThreadsByUserUseCase> {
        self { FetchThreadsByUserUseCase(threadsRepository: self.threadsRepository()) }
    }
    
    var likeThreadUseCase: Factory<LikeThreadUseCase> {
        self { LikeThreadUseCase(authRepository: self.authenticationRepository(), threadRepository: self.threadsRepository()) }
    }
}


extension Container {
    
    var authenticationDataSource: Factory<AuthenticationDataSource> {
        self { FirebaseAuthenticationDataSourceImpl() }.singleton
    }
    
    var authenticationRepository: Factory<AuthenticationRepository> {
        self { AuthenticationRepositoryImpl(authenticationDataSource: self.authenticationDataSource()) }.singleton
    }
    
    var signOutUseCase: Factory<SignOutUseCase> {
        self { SignOutUseCase(repository: self.authenticationRepository()) }
    }
    
    var verifySessionUseCase: Factory<VerifySessionUseCase> {
        self { VerifySessionUseCase(authRepository: self.authenticationRepository(), userProfileRepository: self.userProfileRepository()) }
    }
    
    var signInUseCase: Factory<SignInUseCase> {
        self { SignInUseCase(authRepository: self.authenticationRepository(), userProfileRepository: self.userProfileRepository()) }
    }
    
    var signUpUseCase: Factory<SignUpUseCase> {
        self { SignUpUseCase(authRepository: self.authenticationRepository(), userRepository: self.userProfileRepository()) }
    }
    
    var forgotPasswordUseCase: Factory<ForgotPasswordUseCase> {
        self { ForgotPasswordUseCase(authRepository: self.authenticationRepository()) }
    }
}

extension Container {
    
    var userMapper: Factory<UserMapper> {
        self { UserMapper() }.singleton
    }
    
    var userDataSource: Factory<UserDataSource> {
        self { FirestoreUserDataSourceImpl() }.singleton
    }
    
    var userProfileRepository: Factory<UserProfileRepository> {
        self { UserProfileRepositoryImpl(userDataSource: self.userDataSource(), storageFilesDataSource: self.storageDataSource(), userMapper: self.userMapper(), authenticationRepository: self.authenticationRepository()) }.singleton
    }
    
    var updateUserUseCase: Factory<UpdateUserUseCase> {
        self { UpdateUserUseCase(userRepository: self.userProfileRepository(), authRepository: self.authenticationRepository()) }
    }
    
    var getCurrentUserUseCase: Factory<GetCurrentUserUseCase> {
        self { GetCurrentUserUseCase(authRepository: self.authenticationRepository(), userRepository: self.userProfileRepository())}
    }
    
    var getSuggestionsUseCase: Factory<GetSuggestionsUseCase> {
        self { GetSuggestionsUseCase(userRepository: self.userProfileRepository(), authRepository: self.authenticationRepository()) }
    }
    
    var followUserUseCase: Factory<FollowUserUseCase> {
        self { FollowUserUseCase(authRepository: self.authenticationRepository(), userProfileRepository: self.userProfileRepository()) }
    }
    
    var searchUsersUseCase: Factory<SearchUsersUseCase> {
        self { SearchUsersUseCase(userRepository: self.userProfileRepository(), authRepository: self.authenticationRepository()) }
    }
}

extension Container {

    var notificationsDataSource: Factory<NotificationsDataSource> {
        self { FirestoreNotificationsDataSourceImpl() }.singleton
    }
}

extension Container {
    
    var eventBus: Factory<EventBus<AppEvent>> {
        self { EventBus<AppEvent>() }.singleton
    }
}
