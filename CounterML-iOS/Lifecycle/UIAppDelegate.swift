//
//  AppDelegate.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 21.01.2023.
//

#if canImport(UIKit)
import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
#endif
