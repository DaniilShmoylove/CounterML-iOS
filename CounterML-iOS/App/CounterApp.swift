//
//  CounterApp.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 16.01.2023.
//

import SwiftUI
import CounterMLKit
import Helpers
import Services

@main
struct CounterApp: App {
    private let backgroundTaskManager = BackgroundTaskManager()
    private let persistenceContainer = PersistenceContainer.shared
    
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#else
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    
    var body: some Scene {
        WindowGroup {
            AppView()
            
                //MARK: - ManagedObjectContext
                
                .environment(
                    \.managedObjectContext,
                     self.persistenceContainer.viewContext
                )
        }
        
        //MARK: - Background task
        
        /// Update classification data base in background
        
        .backgroundTask(
            .appRefresh(BGManager.identifier)
        ) {
            BGManager.scheduleAppRefresh()
            await self.backgroundTaskManager.updateClassificationData()
        }
        
#if os(macOS)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
