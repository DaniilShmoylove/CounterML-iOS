//
//  AppDelegate.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 21.01.2023.
//

#if canImport(UIKit)
import SwiftUI
import Core
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    //MARK: - App did finish launch
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        self.configureAppearance()
        
        FirebaseApp.configure()
        return true
    }
    
    //MARK: - Options
    
    func application(
        _ application: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

extension AppDelegate {
    
    //MARK: - Configure appearance
    
    private func configureAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.roundedFont(ofSize: 36, weight: .black)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.roundedFont(ofSize: 18, weight: .semibold)
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.roundedFont(ofSize: 11, weight: .medium)],
            for: .normal
        )
        
        UIView.appearance(
            whenContainedInInstancesOf: [UIAlertController.self]
        ).tintColor = .label
    }
}
#endif
