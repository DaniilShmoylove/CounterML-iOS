//
//  NSAppDelegate.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 21.01.2023.
//

#if canImport(AppKit)
import AppKit
import FirebaseCore

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(
        _ notification: Notification
    ) {
        FirebaseApp.configure()
    }
}
#endif
