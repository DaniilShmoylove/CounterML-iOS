//
//  AppAnalytics.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylov on 19.05.2024.
//

import Resolver
import os

//MARK: - AppAnalyticsProvider protocol

public protocol AppAnalyticsProvider {
    func log(_ event: Event)
}

//MARK: - AppAnalytics

final public class AppAnalytics {
    private init() { }
    
    //MARK: AppAnalytics injected
    
    @Injected private static var appAnalytics: AppAnalyticsProvider
    
    //MARK: log
    
    /// This method logs analytics events
    ///
    /// - Tag: log
    public static func log(
        _ event: Event
    ) {
#if DEBUG
        Logger.global.info("AppAnalytics: \(event.rawValue)")
#else
        self.appAnalytics.log(event)
#endif
    }
}
