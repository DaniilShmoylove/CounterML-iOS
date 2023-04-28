//
//  MealPersistenceService.swift
//  
//
//  Created by Daniil Shmoylove on 10.04.2023.
//

import Foundation
import CoreData
import SharedModels
import Resolver

public protocol MealPersistenceService {
    
    func saveItem(
        _ data: MealModel
    ) throws
    
    func deleteItem(
        _ data: MealEntity
    ) throws
    
    func refresh()
}

final public class MealPersistenceServiceImpl {
    public init() { }
    
    //MARK: - PersistenceContainer
    
    private let container = PersistenceContainer.shared
}

extension MealPersistenceServiceImpl: MealPersistenceService {
    
    public func saveItem(
        _ data: MealModel
    ) throws {
        let newItem = MealEntity(
            context: self.container.viewContext
        )
        newItem.asModel = data
        
        self.container.saveContext()
    }
    
    public func deleteItem(
        _ data: MealEntity
    ) throws {
        self.container.viewContext.delete(data)
        self.container.saveContext()
    }
    
    public func reload() {
        self.container.viewContext.refreshAllObjects()
    }
    
    public func refresh() {
        self.container.viewContext.refreshAllObjects()
    }
}
