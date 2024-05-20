//
//  Event.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylov on 19.05.2024.
//

public enum Event: String {
    case LAUNCH_APP
    
    //MARK: - Authentication
    
    case AUTHENTICATION_SIGN_IN_WITH_GOOGLE
    case AUTHENTICATION_SIGN_IN
    case AUTHENTICATION_SIGN_UP
    case AUTHENTICATION_SIGN_OUT
}
