//
//  NSAppDelegate.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 21.01.2023.
//

#if canImport(AppKit)
import AppKit
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(
        _ notification: Notification
    ) {
        FirebaseApp.configure()
    }
    
    func applicationDidFinishLaunching(
        _ notification: Notification
    ) {
        let appleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(
            self,
            andSelector: Selector(("handleGetURLEvent:replyEvent:")),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }
    
    func handleGetURLEvent(
        event: NSAppleEventDescriptor?,
        replyEvent: NSAppleEventDescriptor?
    ) {
        if let urlString = event?
            .paramDescriptor(
                forKeyword: AEKeyword(keyDirectObject)
            )?.stringValue {
            if let url = NSURL(string: urlString) as? URL {
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
#endif
