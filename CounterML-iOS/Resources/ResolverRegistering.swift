//
//  ResolverRegistering.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 19.01.2023.
//

import Resolver
import Services

//MARK: - ResolverRegistering

/// Resolver is a Dependency Injection registry that registers Services for later
/// resolution and injection into newly constructed instances.
/// - Tag: ResolverRegistering
extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        
        //MARK: - Register MLService
        
        /// Service responsible for processing data in the Food CoreML model.
        /// The main task of the class is to provide an API for processing data in the model.
        ///
        /// - Tag: Register MLService
        register { MLServiceImpl() }
            .implements(MLService.self)
        
        //MARK: - Register CameraService
        
        /// Service for processing data from the camera and its transfer.
        /// The main task of the class is to provide an API for taking photos.
        ///
        /// - Tag: Register CameraService
        register { CameraServiceImpl() }
            .implements(CameraService.self)
        
        //MARK: - Register StorageService
        
        /// Service that interacts with the Firestore database.
        /// The main task of the class is to provide an API for interacting with database data.
        ///
        /// - Tag: Register StorageService
        register { StorageServiceImpl() }
            .implements(StorageService.self)
            .scope(.application)
        
        //MARK: - Register PersistenceContainer
        
        /// A global container that encapsulates the Core Data stack in app.
        ///
        /// - Tag: Register PersistenceContainer
        register { PersistenceContainer() }
            .scope(.application)
        
        //MARK: - Register ClassificationPersistenceService
        
        /// Service that provides an API for managing a `CoreData`
        /// The main task of the class is to receive, save, search for classification data
        ///
        /// - Tag: Register ClassificationPersistenceService
        register { ClassificationPersistenceServiceImpl() }
            .implements(ClassificationPersistenceService.self)
        
        //MARK: - Register AuthenticationService
        
        /// Service that provides an API for `Firebase` user authentication
        /// The main task of the class is to authenticate, sign out, the user
        ///
        /// - Tag: Register AuthenticationService
        register { AuthenticationServiceImpl() }
            .implements(AuthenticationService.self)
            .scope(.application)
        
        //MARK: - KeychainService protocol

        /// Keychain Services is a secure storage interface for macOS and iOS
        /// best used for small pieces of private data like passwords, cookies, and authentication tokens.
        ///
        /// - Tag: KeychainService
        register { KeychainServiceImpl() }
            .implements(KeychainService.self)
            .scope(.unique)
        
        //MARK: - MealPersistenceService protocol
        
        register { MealPersistenceServiceImpl() }
            .implements(MealPersistenceService.self)
    }
}
