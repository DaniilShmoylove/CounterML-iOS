//
//  SummaryViewModel.swift
//  
//
//  Created by Daniil Shmoylove on 10.04.2023.
//

import Foundation
import SharedModels
import Resolver
import Services

final class SummaryViewModel: ObservableObject {
    init() { }
    
    @Injected private var mealPersistenceService: MealPersistenceService
    
    func addMock() {
        try? self.mealPersistenceService.saveItem(.init(name: "Pizza", weight: 100, calories: 432, carbs: 43, fat: 8, protein: 12, date: .now))
    }
    
    func delete(_ data: MealEntity) {
        try? self.mealPersistenceService.deleteItem(data)
    }
    
    func refresh() {
        self.mealPersistenceService.refresh()
    }
}
