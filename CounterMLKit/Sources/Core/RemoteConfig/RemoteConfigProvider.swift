//
//  RemoteConfigProvider.swift
//
//
//  Created by Daniil Shmoylov on 20.05.2024.
//

//MARK: - RemoteConfigProvider protocol

public protocol RemoteConfigProvider: AnyObject {
    
    //MARK: Initialize
  
    /// This method sets default values ​​for properties and retrieves values ​​from a `remote config`
    ///
    /// - Tag: initialize
    func initialize() async throws
    
    //MARK: Values
    
    var welcomeScreen: String? { get }
}
