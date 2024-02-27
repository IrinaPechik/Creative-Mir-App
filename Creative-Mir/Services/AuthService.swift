//
//  AuthService.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 17.01.2024.
//

import Foundation
import FirebaseAuth
import SwiftKeychainWrapper
import UIKit


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
    // MARK: - Userdefaults methods
    
    // MARK: - Userdefaults methods for all types of users
    
    // MARK: Save and get to/from userDefaults info about person role.
    func saveUserRole(role: String) {
        UserDefaults.standard.set(role, forKey: "userRole")
    }
    
    func getUserRole() -> String {
        if let role = UserDefaults.standard.string(forKey: "userRole") {
            return role
        }
        return "user" 
    }
    
    // MARK: Save and get to/from userDefaults info about person name.
    func saveUserName(name: String) {
        UserDefaults.standard.set(name, forKey: "userName")
    }
    
    func getUserName() -> String {
        if let name = UserDefaults.standard.string(forKey: "userName") {
            return name
        }
        return "name"
    }
    
    // MARK: Save and get to/from userDefaults info about person surname.
    func saveUserSurname(surname: String) {
        UserDefaults.standard.set(surname, forKey: "userSurname")
    }
    
    func getUserSurname() -> String {
        if let surname = UserDefaults.standard.string(forKey: "userSurname") {
            return surname
        }
        return "surname"
    }
    
    // MARK: Save and get to/from userDefaults info about person birth date.
    func saveUserBirthDateStr(birthDateStr: String) {
        UserDefaults.standard.set(birthDateStr, forKey: "userBirthDateStr")
    }
    
    func getUserBirthDateStr() -> String {
        if let birthDateStr = UserDefaults.standard.string(forKey: "userBirthDateStr") {
            return birthDateStr
        }
        return "birth date"
    }
    
    // MARK: Save and get to/from userDefaults profile photo.
    func saveUserProfilePhoto(profilePhotoJpeg: Data?) {
        let encoded = try! PropertyListEncoder().encode(profilePhotoJpeg)
        UserDefaults.standard.set(encoded, forKey: "encodedProfilePhoto")
    }
    
    func getUserProfilePhoto() -> UIImage? {
        guard let data = UserDefaults.standard.data(forKey: "encodedProfilePhoto") else {return nil}
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        let image = UIImage(data: decoded)
        return image
    }
    
    // MARK: - Userdefaults methods for suppliers
    
    // MARK: Save and get to/from userDefaults info about person role.
    func saveSupplierStoryAboutYourself(storyAboutYourself: String) {
        UserDefaults.standard.set(storyAboutYourself, forKey: "supplierStoryAboutYourself")
    }
    
    func getSupplierStoryAboutYourself() -> String {
        if let storyAboutYourself = UserDefaults.standard.string(forKey: "supplierStoryAboutYourself") {
            return storyAboutYourself
        }
        return "storyAboutYourself"
    }
    
    // MARK: - Userdefaults methods for both suppliers and venues
    
    // MARK: Save and get to/from userDefaults info about person company status.
    func savePerformerCompanyOrIndividualStatus(companyOrIndividualStatus: String) {
        UserDefaults.standard.set(companyOrIndividualStatus, forKey: "companyOrIndividualPerformer")
    }
    
    func getPerformerCompanyOrIndividualStatus() -> String {
        if let companyOrIndividualStatus = UserDefaults.standard.string(forKey: "companyOrIndividualPerformer") {
            return companyOrIndividualStatus
        }
        return "companyOrIndividualStatus"
    }
}
