//
//  AuthenticationService.swift
//
//
//  Created by Daniil Shmoylove on 28.02.2023.
//

import Resolver
import FirebaseCore
import SharedModels
import Core
import GoogleSignIn

#if canImport(FirebaseAuth)
import FirebaseAuth
#endif

//MARK: - AuthenticationService protocol

/// Service that provides an API for `Firebase` user authentication.
/// The main task of the class is to authenticate, sign out, the user.
///
/// > To handle user data, use the ``UserService`` class.
///
/// - Tag: AuthenticationService
public protocol AuthenticationService {
    func signInWithGoogle() async throws
    func signIn(_ signCredential: SignCredential) async throws
    func signUp(_ signCredential: SignCredential) async throws
    func signOut() throws
}

//MARK: - AuthenticationServiceImpl

final public class AuthenticationServiceImpl {
    public init() { }
    
    //MARK: - KeychainService
    
    @Injected private var keychainService: KeychainService
    
    //MARK: - AuthCredential
    
    /// This credential is created  by GoogleSignIn and Email & Password
    ///
    /// - Tag: Credential
    private var credential: AuthCredential?
}

/// - Tag: AuthenticationServiceImpl
extension AuthenticationServiceImpl: AuthenticationService {
    
    //MARK: - SignInWithGoogle
    
    /// This method creates credentials for `GoogleSignIn`
    ///
    /// - Tag: SignInWithGoogle
    @MainActor
    public func signInWithGoogle() async throws {
#if os(iOS)
        let scenes = UIApplication.shared.connectedScenes
        
        guard
            let windowScene = scenes.first as? UIWindowScene,
            let viewController = windowScene.windows.first?.rootViewController
        else { return }
#else
        guard
            let keyWindow = NSApplication.shared.keyWindow
        else { return }
#endif
        
        guard
            let clientID = FirebaseApp.app()?.options.clientID
        else { return }
        
        /// Set active configuration for this instance of GIDSignIn.
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        do {
            
            /// Starts sign in flow
            
#if os(iOS)
            let result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: viewController
            )
#else
            let result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: keyWindow
            )
#endif
            
            guard
                let idToken = result.user.idToken?.tokenString
            else { return }
            
            /// Create google credential
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            self.credential = credential
            
            /// authenticate
            
            try await self.authenticate()
        } catch {
            throw error
        }
    }
    
    //MARK: - SignIn
    
    /// This method creates credentials for `Email & Password`
    ///
    /// - Tag: SignIn
    public func signIn(_ signCredential: SignCredential) async throws {
        do {
            self.credential = EmailAuthProvider
                .credential(
                    withEmail: signCredential.email,
                    password: signCredential.password
                )
            
            try await self.authenticate()
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
    private func authenticate(
    ) async throws -> AuthDataResult? {
        guard let credential = self.credential else { return nil }
        
        do {
            let result = try await Auth.auth().signIn(with: credential)
            return result
        } catch {
            throw error
        }
    }
    
    //MARK: - Sign up
    
    /// Registers a new user.
    ///
    /// > This method implements the work of ``KeychainService``.
    /// > When a user creates an account, his data is stored in `Keychain`.
    ///
    /// - Tag: SignUp
    public func signUp(_ signCredential: SignCredential) async throws {
        do {
            let result = try await Auth.auth()
                .createUser(
                    withEmail: signCredential.email,
                    password: signCredential.password
                )
            
            self.credential = result.credential
            
            try self.keychainService.save(signCredential)
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
