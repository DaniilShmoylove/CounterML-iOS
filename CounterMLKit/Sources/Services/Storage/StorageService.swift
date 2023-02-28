//
//  StorageService.swift
//  
//
//  Created by Daniil Shmoylove on 24.02.2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SharedModels

//MARK: - StorageService protocol

/// Service that interacts with the `Firestore` database.
/// The main task of the class is to provide an API for interacting with database data.
///
/// - Tag: StorageService
public protocol StorageService {
    
    /// Fetch an object of `ClassificationModel` type for a query by classification name
    
    func fetchClassifierDocument(
        for name: String
    ) async throws -> ClassificationModel
    
    /// Retrieves all classification data from Firestore.
    
    func fetchAllClassifierDocuments() async throws -> [ClassificationModel]
}

//MARK: - StorageServiceImpl

/// - Tag: StorageServiceImpl
final public class StorageServiceImpl {
    public init() { }
    
    //MARK: - Data base object
    
    /// - Tag: Database
    private lazy var database = Firestore.firestore()
}

extension StorageServiceImpl: StorageService {
    
    //MARK: - Fetch classifier document
    
    /// Fetch an object of `ClassificationModel` type for a query by classification name
    ///
    /// - Parameters:
    ///     - name: Must not be empty
    ///
    /// - Returns: Model `ClassificationModel` by classification name.
    ///
    /// - Tag: FetchClassifierDocument
    @discardableResult
    public func fetchClassifierDocument(
        for name: String
    ) async throws -> ClassificationModel {
        let foodRef = self.database.collection(StoragePath.classifierCollection)
        let nameQuery = foodRef.document(name)
        
        do {
            let document = try await nameQuery.getDocument(as: ClassificationModel.self)
            return document
        } catch {
            throw error
        }
    }
    
    //MARK: - Fetch all classifier documents
    
    /// Retrieves all classification data from Firestore.
    ///
    /// - Tag: FetchAllClassifierData
    @discardableResult
    public func fetchAllClassifierDocuments(
    ) async throws -> [ClassificationModel] {
        let foodRef = self.database.collection(StoragePath.classifierCollection)
        
        do {
            let query = try await foodRef.getDocuments()
            let documents = try query.documents.compactMap { try $0.data(as: ClassificationModel.self) }
            return documents
        } catch {
            throw error
        }
    }
}

//MARK: - Storage path

/// Specifies the path to a collection or document in a firestore database
///
/// - Tag: StoragePath
fileprivate enum StoragePath {
    static let classifierCollection: String = "Food"
}
