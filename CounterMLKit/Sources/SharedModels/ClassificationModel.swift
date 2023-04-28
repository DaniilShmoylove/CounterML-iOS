//
//  ClassificationModel.swift
//  
//
//  Created by Daniil Shmoylove on 02.02.2023.
//

import Foundation

//MARK: - ClassificationModel

/// This model is used to classify a dish and store it.
/// 
/// - Tag: ClassificationModel
public struct ClassificationModel: Hashable, Identifiable, Codable, Equatable {
    
    //MARK: - Empty init
    
    public init(imageData: Data? = nil) {
        self.imageData = imageData
        self.name = .init()
        self.description = nil
        self.calories = .init()
        self.carbs = .init()
        self.fat = .init()
        self.protein = .init()
    }
    
    //MARK: - Fields
    
    public var id: Data? { self.imageData }
    public var imageData: Data?
    public var name: String
    public var description: String?
    public var calories: Int
    public var carbs: Int
    public var fat: Int
    public var protein: Int
    
    //MARK: - CodingKeys
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case calories
        case carbs
        case fat
        case protein
    }
    
    //MARK: - Decode
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.calories = try container.decode(Int.self, forKey: .calories)
        self.carbs = try container.decode(Int.self, forKey: .carbs)
        self.fat = try container.decode(Int.self, forKey: .fat)
        self.protein = try container.decode(Int.self, forKey: .protein)
    }
    
    //MARK: - Encode
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.calories, forKey: .calories)
        try container.encode(self.carbs, forKey: .carbs)
        try container.encode(self.fat, forKey: .fat)
        try container.encode(self.protein, forKey: .protein)
    }
    
    public static func == (lhs: ClassificationModel, rhs: ClassificationModel) -> Bool {
        return lhs.imageData == rhs.imageData &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description &&
        lhs.calories == rhs.calories &&
        lhs.carbs == rhs.carbs &&
        lhs.fat == rhs.fat &&
        lhs.protein == rhs.protein
    }
}
