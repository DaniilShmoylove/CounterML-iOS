//
//  ManagedObjectContextExtension.swift
//  
//
//  Created by Daniil Shmoylove on 26.02.2023.
//

import CoreData

public extension NSManagedObjectContext {
    
    //MARK: - Save current context
    
    /// Saves the current context if there were any changes.
    ///
    /// - Tag: SaveContext
    @inlinable
    @inline(__always)
    func saveContext() {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                self.rollback()
                fatalError("Unresolved error \((error as NSError).debugDescription)")
            }
        }
        
        print("CoreData: has been saved changes, \(#function)")
    }
}
