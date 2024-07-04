//
//  DebugViewModel.swift
//
//
//  Created by Daniil Shmoylov on 03.07.2024.
//

import Foundation
import Resolver
import Authentication
import Services

@MainActor final class DebugViewModel: ObservableObject {
    init() { }
    
    @Injected private var authenticationService: AuthenticationService
    
    func signOut() {
        do {
            try authenticationService.signOut()
        } catch {
            
        }
    }
}
