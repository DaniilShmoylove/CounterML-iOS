//
//  AuthenticationService.swift
//  
//
//  Created by Daniil Shmoylove on 28.02.2023.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn

//MARK: - AuthenticationService protocol

/// Service that provides an API for `Firebase` user authentication
/// The main task of the class is to authenticate, sign out, the user
///
/// - Tag: PersistenceService
public protocol AuthenticationService {
    func createGoogleCredential() async throws
    func authenticate() async throws
    func signOut() throws
}

//MARK: - AuthenticationServiceImpl

final public class AuthenticationServiceImpl {
    public init() { }
    //MARK: - AuthCredential
    
    /// - Tag: Credential
    private var credential: AuthCredential?
}

/// - Tag: AuthenticationServiceImpl
extension AuthenticationServiceImpl: AuthenticationService {
    
    //MARK: - CreateGoogleCredential
    
    /// This method creates credentials for `GoogleSignIn`
    ///
    /// - Tag: CreateGoogleCredential
    public func createGoogleCredential() async throws {
        let scenes = await UIApplication.shared.connectedScenes
        
        guard
            let windowScene = scenes.first as? UIWindowScene,
            let viewController = await windowScene.windows.first?.rootViewController
        else { return }
        
        guard
            let clientID = FirebaseApp.app()?.options.clientID
        else { return }
        
        do {
            
            /// Starts sign in flow
            
            let result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: viewController
            )
            
            guard
                let idToken = result.user.idToken?.tokenString
            else { return }
            
            /// Set active configuration for this instance of GIDSignIn.
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            /// Create google credential
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            self.credential = credential
        } catch {
            throw error
        }
    }
    
    //MARK: - Authenticate
    
    /// Login with user `credential`.
    ///
    /// - Tag: SignIn
    public func authenticate() async throws {
        guard let credential = self.credential else { return }
        try await Auth.auth().signIn(with: credential)
    }
    
    //MARK: - Sign out
    
    /// - Tag: SignOut
    public func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw error
        }
    }
}
