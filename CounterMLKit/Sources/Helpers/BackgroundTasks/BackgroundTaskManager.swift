//
//  BackgroundTaskManager.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 28.02.2023.
//

import BackgroundTasks
import Resolver
import Services
import Core

//MARK: - BGManager typealias

public typealias BGManager = BackgroundTaskManager

//MARK: - BackgroundTaskManager

/// Manager the specified actions when the system provides a background task.
///
/// - Tag: BackgroundTaskManager
final public class BackgroundTaskManager {
    public init() { }
    
    //MARK: - Identifier
    
    public static var identifier: String = AppKeys.Identifier.bgTaskManager
    
    //MARK: - StorageService
    
    @Injected private var storageService: StorageService
    
    //MARK: - ClassificationPersistenceService
    
    @Injected private var classificationPersistenceService: ClassificationPersistenceService
    
    //MARK: - UpdateClassificationData
    
    /// Updates the classification data if it is not loaded
    ///
    /// - Tag: UpdateClassificationData
    public func updateClassificationData() async {
        guard
            self.classificationPersistenceService.isNonDataUploaded
        else { return }
        
        do {
            let classifications = try await self.storageService.fetchAllClassifierDocuments()
            try self.classificationPersistenceService.downloadClassificationData(classifications)
        } catch {
            fatalError("Error: download data error: \(error.localizedDescription)")
        }
    }
    
    //MARK: - ScheduleAppRefresh
    
    public static func scheduleAppRefresh() {
#if os(macOS)
        
#else
        let request = BGProcessingTaskRequest(
            identifier: Self.identifier
        )
        
        /// Fetch no earlier than 1 hour from now.
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60)
        try? BGTaskScheduler.shared.submit(request)
#endif
    }
}
