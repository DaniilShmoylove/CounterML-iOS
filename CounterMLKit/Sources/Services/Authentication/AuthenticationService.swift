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

/// Service that provides an API for `Firebase` user authentication.
/// The main task of the class is to authenticate, sign out, the user.
///
/// > To handle user data, use the ``UserService`` class.
///
/// - Tag: AuthenticationService
public protocol AuthenticationService {
    func createGoogleCredential() async throws
    func authenticate() async throws -> AuthDataResult?
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
    @MainActor
    public func createGoogleCredential() async throws {
        let scenes = UIApplication.shared.connectedScenes
        
        guard
            let windowScene = scenes.first as? UIWindowScene,
            let viewController = windowScene.windows.first?.rootViewController
        else { return }
        
        guard
            let clientID = FirebaseApp.app()?.options.clientID
        else { return }
        
        /// Set active configuration for this instance of GIDSignIn.
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        do {
            
            /// Starts sign in flow
            
            let result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: viewController
            )
            
            guard
                let idToken = result.user.idToken?.tokenString
            else { return }
            
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
    /// > Use this method only after the `credential` has been created.
    ///
    /// - Returns: A object of `AuthDataResult?` type.
    ///
    /// - Tag: Authenticate
    @discardableResult
    public func authenticate(
    ) async throws -> AuthDataResult? {
        guard let credential = self.credential else { return nil }
        
        do {
            let result = try await Auth.auth().signIn(with: credential)
            return result
        } catch {
            throw error
        }
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
