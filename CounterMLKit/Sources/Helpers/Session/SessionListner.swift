//
//  SessionListner.swift
//  
//
//  Created by Daniil Shmoylove on 03.03.2023.
//

import FirebaseAuth

//MARK: - SessionListener

/// This is the class that listens for the user's auth state.
///
/// - Tag: SessionListener
final public class SessionListener: ObservableObject {
    public init() { }
    
    //MARK: - IsAuthenticated
    
    @Published public var isAuthenticated: Bool = false
    
    //MARK: - Auth state handler
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: - Start listener
    
    public func startListener() {
        self.handle = Auth.auth()
            .addStateDidChangeListener { (_, user) in
                self.isAuthenticated = (user != nil)
            }
    }
    
    // MARK: - Clear handle
    
    deinit {
        if let handle = self.handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
