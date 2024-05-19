//
//  Logger.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylov on 19.05.2024.
//

import Foundation
import os

//MARK: - Logger

public extension Logger {
    
    //MARK: Subsystem
    
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    //MARK: - Categories
    
    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(
        subsystem: subsystem,
        category: "viewcycle"
    )

    /// All logs related to tracking and analytics.
    static let statistics = Logger(
        subsystem: subsystem,
        category: "statistics"
    )
    
    /// All logs related to tracking and analytics.
    static let authentication = Logger(
        subsystem: subsystem,
        category: "authentication"
    )
    
    /// All global logs.
    static let global = Logger(
        subsystem: subsystem,
        category: "global"
    )
}
