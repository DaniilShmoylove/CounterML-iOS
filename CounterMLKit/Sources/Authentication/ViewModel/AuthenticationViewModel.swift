//
//  AuthenticationViewModel.swift
//  
//
//  Created by Daniil Shmoylove on 01.03.2023.
//

import Foundation
import Resolver
import Services
import SharedModels

final class AuthenticationViewModel: ObservableObject {
    init() { }
    
    @Injected private var authenticationService: AuthenticationService
    
    @Published private(set) var isCredentialLoading: Bool = false
    @Published var error: String = .init()
}

extension AuthenticationViewModel {
    
    @MainActor
    func createGoogleCredential() {
        Task {
            do {
                self.isCredentialLoading = true 
                try await self.authenticationService.signInWithGoogle()
                self.isCredentialLoading = false
            } catch {
                self.error = error.localizedDescription
                self.isCredentialLoading = false
            }
        }
    }
    
    @MainActor
    func signOut() {
        do {
            try self.authenticationService.signOut()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    @MainActor
    func signUp(credential: SignCredential) {
        Task {
            do {
                try await self.authenticationService.signUp(credential)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
    
    @MainActor
    func signInWithEmail(credential: SignCredential) {
        Task {
            do {
                try await self.authenticationService.signIn(credential)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}
