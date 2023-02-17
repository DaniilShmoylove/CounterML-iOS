//
//  CounterApp.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 16.01.2023.
//

import SwiftUI

//TODO: - Prepare CounterMLKit

import CounterMLKit
import Services

@main
struct CounterApp: App {
    
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
    }
#endif
}
