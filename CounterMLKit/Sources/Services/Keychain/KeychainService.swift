//
//  KeychainManager.swift
//
//
//  Created by Daniil Shmoylove on 08.04.2023.
//

import Foundation
import Security
import SharedModels

//MARK: - KeychainService protocol

/// Keychain Services is a secure storage interface for macOS and iOS
/// best used for small pieces of private data like passwords, cookies, and authentication tokens.
///
/// - Tag: KeychainService
public protocol KeychainService {
    func save(_ keychainData: SignCredential) throws
    func update(_ keychainData: SignCredential) throws
    func get(_ keychainData: SignCredential) throws -> Data
}

//MARK: - KeychainServiceImpl

final public class KeychainServiceImpl {
    public init() { }
    
    //MARK: - Errors
    
    /// - Tag: KeychainError
    public enum KeychainError: Error {
        
        /// Attempted read for an item that does not exist.
        
        case itemNotFound
        
        /// Attempted save to override an existing item.
        /// Use update instead of save to update existing items
        
        case duplicateItem
        
        /// A read of an item in any format other than Data
        
        case invalidItemFormat
        
        /// Any operation result status than errSecSuccess
        
        case unexpectedStatus(OSStatus)
    }
}

/// - Tag: KeychainServiceImpl
extension KeychainServiceImpl: KeychainService {
    
    //MARK: - Save
    
    /// - Tag: Save
    public func save(
        _ keychainData: SignCredential
    ) throws {
        guard
            let password = keychainData.password.data(using: .utf8)
        else { fatalError("Failed to get password as date type \(#function)") }
        
        var query: [String: AnyObject] = [
            
            /// kSecAttrService,  kSecAttrAccount, and kSecClass
            /// uniquely identify the item to save in Keychain
            
            kSecAttrService as String: keychainData.server as AnyObject,
            kSecAttrAccount as String: keychainData.email as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            /// kSecValueData is the item value to save
            
            kSecValueData as String: password as AnyObject
        ]
        
        /// Sync credential with `iCloud`
        
        query[kSecAttrSynchronizable as String] = kCFBooleanTrue
        
        //MARK: - SecItemAdd
        
        /// SecItemAdd attempts to add the item identified by
        /// the query to keychain
        /// SecItemAdd is used to save new items to Keychain.
        /// An item is uniquely identified by query, a `CFDictionary` that specifies the item's:
        ///
        /// > 1. Service, `kSecAttrService`, a string to identify a set of Keychain Items like ``com.my-app.bundle-id``
        /// > 2. Account, `kSetAttrAccount`, a string to identify a Keychain Item within a specific service, like ``username@email.com``
        /// > 3. Class, `kSecClass`, a type of secure data to store in a Keychain Item, like `kSecClassGenericPassword`
        ///
        /// - Returns: The second argument result is an UnsafeMutablePointer to any return value specified by query.
        /// Often no return data is expected and nil can be passed for result.
        ///
        /// - Tag: KeychainError
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )
        
        /// errSecDuplicateItem is a special case where the
        /// item identified by the query already exists. Throw
        /// duplicateItem so the client can determine whether
        /// or not to handle this as an error
        ///
        /// - Tag: ErrSecDuplicateItem
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }
        
        /// Any status other than errSecSuccess indicates the
        /// save operation failed.
        ///
        /// - Tag: ErrSecSuccess
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        //TODO: - Logging
        print("Added password – success")
    }
    
    //MARK: - Update
    
    /// - Tag: Update
    public func update(
        _ keychainData: SignCredential
    ) throws {
        guard
            let password = keychainData.password.data(using: .utf8)
        else { fatalError("Failed to get password as date type \(#function)") }
        
        let query: [String: AnyObject] = [
            
            /// kSecAttrService,  kSecAttrAccount, and kSecClass
            /// uniquely identify the item to update in Keychain
            
            kSecAttrService as String: keychainData.server as AnyObject,
            kSecAttrAccount as String: keychainData.email as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        /// attributes is passed to SecItemUpdate with
        /// kSecValueData as the updated item value
        
        let attributes: [String: AnyObject] = [
            kSecValueData as String: password as AnyObject
        ]
        
        /// SecItemUpdate attempts to update the item identified
        /// by query, overriding the previous value
        
        let status = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )
        
        /// errSecItemNotFound is a special status indicating the
        /// item to update does not exist. Throw itemNotFound so
        /// the client can determine whether or not to handle
        /// this as an error
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        /// Any status other than errSecSuccess indicates the
        /// update operation failed.
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    //MARK: - Get
    
    /// - Tag: Get
    public func get(
        _ keychainData: SignCredential
    ) throws -> Data {
        let query: [String: AnyObject] = [
            
            /// kSecAttrService,  kSecAttrAccount, and kSecClass
            /// uniquely identify the item to read in Keychain
            
            kSecAttrService as String: keychainData.server as AnyObject,
            kSecAttrAccount as String: keychainData.email as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            /// kSecMatchLimitOne indicates keychain should read
            /// only the most recent item matching this query
            
            kSecMatchLimit as String: kSecMatchLimitOne,
            
            /// kSecReturnData is set to kCFBooleanTrue in order
            /// to retrieve the data for the item
            
            kSecReturnData as String: kCFBooleanTrue
        ]
        
        /// SecItemCopyMatching will attempt to copy the item
        /// identified by query to the reference itemCopy
        
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &itemCopy
        )
        
        /// errSecItemNotFound is a special status indicating the
        /// read item does not exist. Throw itemNotFound so the
        /// client can determine whether or not to handle
        /// this case
        
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        /// Any status other than errSecSuccess indicates the
        /// read operation failed.
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        /// This implementation of KeychainInterface requires all
        /// items to be saved and read as Data. Otherwise,
        /// invalidItemFormat is thrown
        
        guard let password = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        return password
    }
}
