//
//  PersistenceContainer.swift
//  
//
//  Created by Daniil Shmoylove on 26.02.2023.
//

import CoreData
import SharedModels

//MARK: - PersistenceContainer

/// A  global container that encapsulates the Core Data stack in app.
///
/// - Tag: PersistenceContainer
final public class PersistenceContainer {
    
    //MARK: - Singleton
    
    /// Singleton
    ///
    /// - Tag: Shared
    public static let shared = PersistenceContainer()
    
    //MARK: - Container
    
    /// - Tag: Container
    private let container: NSPersistentContainer
    
    //MARK: - Context
    
    /// An object space to manipulate and track changes to managed objects.
    ///
    /// - Tag: ViewContext
    public let viewContext: NSManagedObjectContext
    
    //MARK: - Init
    
    public init() {
        guard
            let managedObjectModel = NSManagedObjectModel(
                contentsOf: CoreDataPath.modelURL
            )
        else { fatalError("Failed to retrieve the object model") }
        
        self.container = NSPersistentContainer(
            name: CoreDataPath.modelName,
            managedObjectModel: managedObjectModel
        )
        
        self.container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        /// Update viewContext
        
        self.viewContext = self.container.viewContext
        
        /// This policy merges conflicts between the persistent store’s version
        /// of the object and the current in-memory version by saving
        /// the entire in-memory object to the persistent store.

        self.viewContext.mergePolicy = NSMergePolicy.overwrite
    }
}

extension PersistenceContainer {
    
    //MARK: - Save current context
    
    /// Attempts to commit unsaved changes to registered objects to the context’s parent store.
    ///
    /// - Tag: SaveContext
    public func saveContext() {
        let context = self.container.viewContext
        if context.hasChanges {
            do {
                try self.container.viewContext.save()
            } catch {
                self.container.viewContext.rollback()
                fatalError("Unresolved error \((error as NSError).debugDescription)")
            }
        }
        
        print("CoreData: has been saved changes, \(#function)")
    }
}
