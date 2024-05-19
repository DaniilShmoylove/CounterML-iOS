//
//  CounterApp.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 16.01.2023.
//

import SwiftUI
import CounterMLKit
import Helpers
import FirebaseCore
import GoogleSignIn

@main
struct CounterApp: App {
    private let backgroundTaskManager = BackgroundTaskManager()
    
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#else
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
            
            //MARK: Analytics
            
                .onAppear {
                    AppAnalytics.log(.LAUNCH_APP)
                }
        }
        
#if os(iOS)
        
        //MARK: - Background task
        
        /// Update classification data base in background
        
        .backgroundTask(.appRefresh(BGManager.identifier)) {
            BGManager.scheduleAppRefresh()
            await self.backgroundTaskManager.updateClassificationData()
        }
#endif
        
#if os(macOS)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
