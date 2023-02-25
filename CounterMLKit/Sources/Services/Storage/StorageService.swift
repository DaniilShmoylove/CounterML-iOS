//
//  StorageService.swift
//  
//
//  Created by Daniil Shmoylove on 24.02.2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SharedModels

/// Service that interacts with the `Firestore` database.
/// The main task of the class is to provide an API for interacting with database data.

//MARK: - StorageService protocol

/// - Tag: StorageService
public protocol StorageService {
    
    /// Fetch an object of `ClassificationModel` type for a query by classification name
    
    func fetchClassifierDocument(
        for name: String
    ) async throws -> ClassificationModel
}

//MARK: - StorageServiceImpl

/// - Tag: StorageServiceImpl
final public class StorageServiceImpl {
    public init() { }
    
    //MARK: - Data base object
    
    /// - Tag: Database
    private let database = Firestore.firestore()
}

extension StorageServiceImpl: StorageService {
    
    //MARK: - Fetch classifier document
    
    /// Fetch an object of `ClassificationModel` type for a query by classification name
    ///
    /// - Parameters:
    ///     - name: Must not be empty
    ///
    /// - Returns: Model `ClassificationModel` by classification name.
    /// - Tag: GetClassifierDocument
    @discardableResult
    public func fetchClassifierDocument(
        for name: String
    ) async throws -> ClassificationModel {
        let foodRef = self.database.collection(StoragePath.classifierFood)
        let nameQuery = foodRef.document(name)
        
        do {
            let document = try await nameQuery.getDocument(as: ClassificationModel.self)
            return document
        } catch {
            throw error
        }
    }
}

//MARK: - Storage path

/// Specifies the path to a collection or document in a firestore database
/// - Tag: StoragePath
fileprivate enum StoragePath {
    static let classifierFood: String = "Food"
}
