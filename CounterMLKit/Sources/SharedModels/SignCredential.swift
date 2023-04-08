//
//  SignCredential.swift
//
//
//  Created by Daniil Shmoylove on 02.03.2023.
//

import Foundation

//MARK: - Sign credential

public struct SignCredential {
    public init() { }
    
    //MARK: - Fields
    
    public var email: String = .init()
    public var password: String = .init()
    
    //MARK: - Server
    
    public let server = "Nutrition.com"
}

public extension SignCredential {
    
    //MARK: - Validate all fields
    
    /// - Tag: isValid
    var isValid: Bool {
        self.isValidEmail && self.isValidPassword
    }
    
    //MARK: - Validate Email
    
    /// Check email validation
    ///
    /// - Tag: isValidEmail
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.email)
    }
    
    //MARK: - Validate Password
    
    /// Check password validation
    ///
    /// > `Rules`
    /// > 1. least one uppercase,
    /// > 2. least one digit
    /// > 3. least one lowercase
    /// > 4. least one symbol
    /// > 5. min 8 characters total
    ///
    /// - Tag: IsValidPassword
    var isValidPassword: Bool {
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: self.password)
    }
}
