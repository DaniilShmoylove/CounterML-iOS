//
//  DishModel.swift
//  
//
//  Created by Daniil Shmoylove on 02.02.2023.
//

import Foundation

//MARK: - Typealias

public typealias Dish = DishModel 

//MARK: - Dish

/// This model is used to classify a dish and store it.
/// - Tag: DishModel
public struct DishModel: Identifiable {
    public init(
        creatingDate: Date = .init(),
        imageData: Data? = nil,
        name: String = .init(),
        confidencePercentage: String = .init(),
        calories: CGFloat = .init(),
        carbs: CGFloat = .init(),
        weight: String = .init(),
        description: String = .init()
    ) {
        self.creatingDate = creatingDate
        self.imageData = imageData
        self.name = name
        self.confidencePercentage = confidencePercentage
        self.calories = calories
        self.carbs = carbs
        self.weight = weight
        self.description = description
    }
    
    public var id: Data? { self.imageData }
    public var creatingDate: Date
    public var imageData: Data?
    public var name: String
    public var confidencePercentage: String
    public var calories: CGFloat
    public var carbs: CGFloat
    public var weight: String
    public var description: String?
}

//MARK: - Equatable

extension DishModel: Equatable {
    public static func == (
        lhs: DishModel,
        rhs: DishModel
    ) -> Bool {
          return lhs.creatingDate == rhs.creatingDate
      }
}

//MARK: - Extensions

public extension DishModel {
    
    /// Сhecks if a imageData has a value
    /// - Tag: IsHasImageData
    var isHasImageData: Bool { self.imageData != nil }
}
