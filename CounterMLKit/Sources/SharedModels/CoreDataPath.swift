//
//  CoreDataPath.swift
//  
//
//  Created by Daniil Shmoylove on 25.02.2023.
//

import Foundation

//MARK: - CoreData path

/// This is an enum to specify the path of the model
/// - Tag: PersistenceService
public enum CoreDataPath {
    
    //MARK: - Model name
    
    public static let modelName: String = "CounterModel"
    
    //MARK: - Entity name
    
    public static let entityName: String = "ClassificationEntity"
    
    //MARK: - Model url
    
    public static let modelURL = Bundle.module.url(
        forResource: CoreDataPath.modelName,
        withExtension: ".momd"
    )!
}
