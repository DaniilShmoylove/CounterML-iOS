//
//  FirebaseRCRepository.swift
//
//
//  Created by Daniil Shmoylov on 20.05.2024.
//

import FirebaseRemoteConfig

//MARK: - FirebaseRCRepository

public class FirebaseRCRepository: RemoteConfigProvider {
    public init() { }
    
    /// The instance of Remote Config service.
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    /// The standard user defaults object.
    private let defaults = UserDefaults.standard
    
    /// Initializes the Firebase Remote Config repository asynchronously.
    ///
    /// - Tag: initialize
    public func initialize() async throws {
        loadDefaultValues()
        
        do {
            try await fetchCloudValues()
        } catch {
            throw error
        }
    }
    
    //MARK: Values
    
    @Published public var welcomeScreen: String? = nil
    
    /// Loads default values for Remote Config.
    ///
    /// - Tag: loadDefaultValues
    private func loadDefaultValues() {
        let appDefaults: [String: Any?] = [
            RCValueKey.welcomeScreen.rawValue: "default"
        ]
        
        self.remoteConfig.setDefaults(appDefaults as? [String: NSObject])
    }
    
    /// Fetches values from the cloud asynchronously.
    ///
    /// - Tag: fetchCloudValues
    private func fetchCloudValues() async throws {
        activateDebugMode()
        
        do {
            let status = try await remoteConfig.fetchAndActivate()
            
            if status == .successFetchedFromRemote ||
                status == .successUsingPreFetchedData {
                
                // MARK: - Fetched values
                
                if let welcomeScreen = defaults.string(
                    forKey: RCValueKey.welcomeScreen.rawValue
                ) {
                    self.welcomeScreen = welcomeScreen
                }
            }
        } catch {
            throw error
        }
    }
    
    /// Activates debug mode for Remote Config settings.
    ///
    /// - Tag: activateDebugMode
    private func activateDebugMode() {
        let settings = RemoteConfigSettings()
#if DEBUG
        // MARK: Don't actually do this in production!
        settings.minimumFetchInterval = 0
#else
        settings.minimumFetchInterval = 3600
#endif
        RemoteConfig.remoteConfig().configSettings = settings
    }
}
