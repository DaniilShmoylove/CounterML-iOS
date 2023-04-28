//
//  MealEntityExtension.swift
//  
//
//  Created by Daniil Shmoylove on 10.04.2023.
//

import SharedModels
import CoreData

public extension MealEntity {
    
    //MARK: - Fetch entity
    
    /// Search an object entity by string `name`.
    ///
    ///
    /// - Parameters:
    ///     - predicateString: a name of `ClassificationEntity`, a definition of logical
    ///     conditions for constraining a search for a fetch or for in-memory filtering.
    ///
    /// - Tag: SearchEntity
    @discardableResult
    @inlinable
    static func fetch() -> NSFetchRequest<MealEntity> {
        let request = NSFetchRequest<MealEntity>(
            entityName: CoreDataPath.Entities.meal
        )
        
        let today = Date()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: today)
        let endDate = calendar.date(
            byAdding: .day,
            value: 1,
            to: startDate
        )!
        
        let format = "(date >= %@) AND (date < %@)"
        request.predicate = NSPredicate(
            format: format,
            startDate as NSDate,
            endDate as NSDate
        )
        
        request.sortDescriptors = [
            NSSortDescriptor(
                key: "date",
                ascending: true
            )
        ]
        return request
    }
    
    //MARK: - As model
    
    /// Сonverts data from `MealEntity` to `MealModel`
    ///
    /// - Tag: Classification
    var asModel: MealModel {
        get {
            let model = MealModel(
                name: self.name ?? .init(),
                weight: Int(self.weight),
                calories: Int(self.calories),
                carbs: Int(self.carbs),
                fat: Int(self.fat),
                protein: Int(self.protein),
                date: self.date ?? .init()
            )
            return model
        }
        set {
            self.name = newValue.name
            self.weight = Int16(newValue.weight)
            self.calories = Int16(newValue.calories)
            self.carbs = Int16(newValue.carbs)
            self.fat = Int16(newValue.fat)
            self.protein = Int16(newValue.protein)
            self.date = newValue.date
        }
    }
    
    func reload() {
    }
}
