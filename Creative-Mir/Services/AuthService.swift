//
//  AuthService.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 17.01.2024.
//

import Foundation
import FirebaseAuth
import SwiftKeychainWrapper


class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    // MARK: - Authentication methods
    
    // MARK: Sign up method
    func signUp(email: String, password: String, completion: @escaping(Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                result.user.getIDTokenForcingRefresh(true) { token, error in
                    if let token = token {
                        self.saveTokenToKeychain(token: token)
                    } else if error != nil {
                        print("Error while getting token")
                    }
                }
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Sign in method
    func signIn(email: String, password: String, completion: @escaping(Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                if !self.isUserAuthenticated() {
                    result.user.getIDTokenForcingRefresh(true) {  token, error in
                        if let token = token {
                            self.saveTokenToKeychain(token: token)
                        } else if error != nil {
                            print("Error while getting token")
                        }
                        
                    }
                }
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
            
        }
    }
    
    // MARK: Sign out method
    func signOut() throws {
        try auth.signOut()
        KeychainWrapper.standard.removeObject(forKey: "userToken")
    }
    
    // MARK: Reset password method
    // После подключения бд проверить на наличие аккаунта
    func resetPassword(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email, completion: { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        })
    }
    // MARK: - Authentication token methods
    
    // MARK: Save token to keychain
    func saveTokenToKeychain(token: String) {
        KeychainWrapper.standard.set(token, forKey: "userToken")
    }
    
    // MARK: Get token from keychain for current user
    func getTokenFromKeyChain() -> String? {
        return KeychainWrapper.standard.string(forKey: "userToken")
    }
    
    // MARK: Check whether user was authenticated
    func isUserAuthenticated() -> Bool {
        return getTokenFromKeyChain() != nil && auth.currentUser != nil
    }
    
    // MARK: Save to userDefaults info about person role.
    func saveUserRole(role: String) {
        UserDefaults.standard.set(role, forKey: "userRole")
    }
    
    func getUserRole() -> String {
        if let role = UserDefaults.standard.string(forKey: "userRole") {
            return role
        }
        return "user" 
    }
}
