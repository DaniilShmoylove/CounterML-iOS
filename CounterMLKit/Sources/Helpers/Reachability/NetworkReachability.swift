//
//  NetworkReachability.swift
//  
//
//  Created by Daniil Shmoylove on 23.02.2023.
//

import Foundation
import Network
import os

//MARK: - NetworkReachability

/// This class provides an API for getting information about the current state of an Internet connection.
/// - Tag: NetworkReachability
final public class NetworkReachability: ObservableObject {
    public init() { self.startMonitor() }
    
    //MARK: - Monitor
    
    /// An observer that you use to monitor and react to network changes.
    /// - Tag: Monitor
    private let monitor = NWPathMonitor()
    
    //MARK: - IsConnected
    
    /// - Tag: IsConnected
    @Published public var isConnected = false
    
    //MARK: - IsExpensive
    
    /// - Tag: IsExpensive
    @Published public var isExpensive = false
    
    private let queue = DispatchQueue(
        label: "NetworkReachability",
        qos: .background
    )
}

extension NetworkReachability {
    
    //MARK: - Start monitor
    
    /// Start listen reachability
    /// - Tag: IsExpensive
    private func startMonitor() {
        self.monitor.start(queue: self.queue)
        
        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                switch path.status {
                case .satisfied:
                    self.isConnected = true
                case .unsatisfied:
                    self.isConnected = false
                case .requiresConnection:
                    self.isConnected = true
                @unknown default:
                    fatalError("Error: unknown connection status in pathUpdateHandler")
                }
                
                self.isExpensive = path.isExpensive
            }
        }
    }
}
