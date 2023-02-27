//
//  PersistenceService.swift
//  
//
//  Created by Daniil Shmoylove on 25.02.2023.
//

import Foundation
import CoreData
import SharedModels
import Resolver

//MARK: - ClassificationPersistenceService

/// Service that provides an API for managing a `CoreData`
/// The main task of the class is to receive, save, search for classification data
/// 
/// - Tag: PersistenceService
public protocol ClassificationPersistenceService {
    
    /// Search an object entity by string `predicateString` asynchronously.
    
    func fetch(
        _ predicateString: String
    ) async throws -> ClassificationEntity?
    
    /// Download `[ClassificationModel]`
    
    func downloadClassificationData(
        _ data: [ClassificationModel]
    ) throws
}

//MARK: - ClassificationPersistenceServiceImpl

final public class ClassificationPersistenceServiceImpl {
    public init() { }
    
    //MARK: - PersistenceContainer
    
    @Injected private var container: PersistenceContainer
}

extension ClassificationPersistenceServiceImpl: ClassificationPersistenceService {
    
    //MARK: - Fetch entity asynchronously
    
    /// Search an object entity by string `name` asynchronously.
    ///
    /// - Parameters:
    ///     - predicateString: a name of `ClassificationEntity`, a definition of logical
    ///     conditions for constraining a search for a fetch or for in-memory filtering.
    ///
    /// - Tag: Fetch
    @discardableResult
    public func fetch(
        _ predicateString: String
    ) async throws -> ClassificationEntity? {
        let request = NSFetchRequest<ClassificationEntity>(
            entityName: CoreDataPath.entityName
        )
        
        let format = "name BEGINSWITH %@"
        request.predicate = NSPredicate(
            format: format,
            predicateString
        )
        
        request.sortDescriptors = [
            NSSortDescriptor(
                key: "name",
                ascending: true
            )
        ]
        
        request.fetchLimit = 1
        
        let entities = try await self.container.viewContext.perform {
            do {
                return try request.execute()
            } catch {
                throw error
            }
        }
        
        return entities.first
    }
    
    //MARK: - Fetch entity
    
    /// Search an object entity by string `name`.
    ///
    /// - Parameters:
    ///     - predicateString: a name of `ClassificationEntity`, a definition of logical
    ///     conditions for constraining a search for a fetch or for in-memory filtering.
    ///
    /// - Tag: Fetch
    @discardableResult
    public func fetch(
        _ predicateString: String
    ) throws -> ClassificationEntity? {
        let request = NSFetchRequest<ClassificationEntity>(
            entityName: CoreDataPath.entityName
        )
        
        let format = "name BEGINSWITH %@"
        request.predicate = NSPredicate(
            format: format,
            predicateString
        )
        
        request.sortDescriptors = [
            NSSortDescriptor(
                key: "name",
                ascending: true
            )
        ]
        
        request.fetchLimit = 1
        
        do {
            let entities = try self.container.viewContext.fetch(request)
            return entities.first
        } catch {
            throw error
        }
    }
    
    //MARK: - Download classification data
    
    /// Download `[ClassificationEntity]` data into a persistent store.
    ///
    /// - Parameters:
    ///    - data: Collection of data that is requested from the server
    ///
    /// - Tag: DownloadClassificationData
    public func downloadClassificationData(
        _ data: [ClassificationModel]
    ) {
        data.forEach {
            ClassificationEntity(
                context: self.container.viewContext
            ).classification = $0
        }
        
        self.container.saveContext()
    }
}
