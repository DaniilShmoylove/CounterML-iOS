//
//  ClassificationEntityExtension.swift
//  
//
//  Created by Daniil Shmoylove on 26.02.2023.
//

import CoreData
import SharedModels

public extension ClassificationEntity {
    
    //MARK: - Fetch entity
    
    /// Search an object entity by string `name`.
    ///
    /// - Parameters:
    ///     - predicateString: a name of `ClassificationEntity`, a definition of logical
    ///     conditions for constraining a search for a fetch or for in-memory filtering.
    ///
    /// - Tag: SearchEntity
    @discardableResult
    @inlinable
    static func fetch(
        _ predicateString: String
    ) -> NSFetchRequest<ClassificationEntity> {
        let request = NSFetchRequest<ClassificationEntity>(
            entityName: CoreDataPath.Entities.classification
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
        
        request.fetchLimit = 3
        return request
    }
    
    //MARK: - Classification
    
    /// Сonverts data from `ClassificationEntity` to `ClassificationModel`
    ///
    /// - Tag: Classification
    var classification: ClassificationModel {
        get {
            var classification = ClassificationModel()
            classification.name = self.name ?? .init()
            classification.description = self.descript ?? .init()
            classification.calories = Int(self.calories)
            classification.carbs = Int(self.carbs)
            classification.fat = Int(self.fat)
            classification.protein = Int(self.protein)
            return classification
        }
        set {
            self.name = newValue.name
            self.descript = newValue.description
            self.calories = Int16(newValue.calories)
            self.carbs = Int16(newValue.carbs)
            self.fat = Int16(newValue.fat)
            self.protein = Int16(newValue.protein)
        }
    }
}

public extension ClassificationEntity {
    func addMock() {
        
    }
}
