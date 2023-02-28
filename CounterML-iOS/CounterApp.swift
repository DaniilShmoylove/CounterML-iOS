//
//  CounterApp.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 16.01.2023.
//

import SwiftUI
import CounterMLKit
import Helpers

@main
struct CounterApp: App {
    
    private let backgroundTaskManager = BackgroundTaskManager()
    
    //MARK: - MacOS scene
    
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SidebarCounterView()
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        
        Settings { }
    }
    
    //MARK: - Other os scene
    
#else
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                CounterView()
                    .tabItem {
                        Label("Today", systemImage: "calendar")
                    }
            }
        }
        
        //MARK: - Background task
        
        /// Update classification data base in background
        
        .backgroundTask(.appRefresh(BGManager.identifier)) {
            BGManager.scheduleAppRefresh()
            await self.backgroundTaskManager.updateClassificationData()
        }
    }
#endif
}
