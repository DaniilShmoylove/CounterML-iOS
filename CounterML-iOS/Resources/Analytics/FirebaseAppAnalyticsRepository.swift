//
//  FirebaseAppAnalyticsRepository.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylov on 19.05.2024.
//

import FirebaseAnalytics

final class FirebaseAppAnalyticsRepository: AppAnalyticsProvider {
    public func log(
        _ event: Event
    ) {
        Analytics
            .logEvent(
                "\(String(describing: event).lowercased())",
                parameters: [
                    AnalyticsParameterItemID: "id-\(event.rawValue)",
                    AnalyticsParameterItemName: event.rawValue,
                    AnalyticsParameterContentType: "cont",
                ]
            )
    }
}
