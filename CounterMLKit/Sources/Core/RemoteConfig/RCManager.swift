//
//  RemoteConfigProvider.swift
//
//
//  Created by Daniil Shmoylov on 20.05.2024.
//

import Foundation
import Resolver
import os

//MARK: - RCManager

final public class RCManager: ObservableObject {
    private init() { self.initialize() }
    
    public static let shared: RCManager = .init()
    
    //MARK: AppAnalytics injected
    
    @Injected private var remoteConfigProvider: RemoteConfigProvider
    
    private func initialize() {
        Task {
            do {
                try await self.remoteConfigProvider.initialize()
                
                self.setupValues()
            } catch {
                Logger.global.error("Remote Config error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Setup values
    
    private func setupValues() {
        self.welcomeScreen = self.remoteConfigProvider.welcomeScreen
        
        Logger.global.info("Remote Config values are loaded")
    }
    
    //MARK: - RCManager values
    
    @Published public var welcomeScreen: String?
}
