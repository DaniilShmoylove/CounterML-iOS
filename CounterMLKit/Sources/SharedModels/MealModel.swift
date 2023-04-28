//
//  MealModel.swift
//  
//
//  Created by Daniil Shmoylove on 10.04.2023.
//

import Foundation

public struct MealModel: Hashable, Identifiable, Codable {
    public init(
        id: UUID = .init(),
        name: String,
        weight: Int,
        calories: Int,
        carbs: Int,
        fat: Int,
        protein: Int,
        date: Date
    ) {
        self.id = id
        self.name = name
        self.weight = weight
        self.calories = calories
        self.carbs = carbs
        self.fat = fat
        self.protein = protein
        self.date = date
    }
    
    
    public let id: UUID
    public var name: String
    public var weight: Int
    public var calories: Int
    public var carbs: Int
    public var fat: Int
    public var protein: Int
    public var date: Date
}

extension MealModel: Equatable {
    public static func == (lhs: MealModel, rhs: MealModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.weight == rhs.weight &&
        lhs.calories == rhs.calories &&
        lhs.carbs == rhs.carbs &&
        lhs.fat == rhs.fat &&
        lhs.protein == rhs.protein &&
        lhs.date == rhs.date
    }
}
