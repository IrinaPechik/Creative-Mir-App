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
        auth.createUser(withEmail: email, password: password) { [self] result, error in
            if let result = result {
                result.user.getIDTokenForcingRefresh(true) { token, error in
                    if let token = token {
                        self.saveTokenToKeychain(token: token)
                    } else if error != nil {
                        print("Error while getting token")
                    }
                }
                self.saveUserId(id: result.user.uid)
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
    
    // MARK: Save and get to/from userDefaults user id.
    func saveUserId(id: String) {
        UserDefaults.standard.set(id, forKey: "userId")
    }
    func getUserId() -> String {
        if let id = UserDefaults.standard.string(forKey: "userId") {
            return id
        }
        return "id"
    }
    
    // MARK: Save and get to/from userDefaults email.
    func saveUserEmail(email: String) {
        UserDefaults.standard.set(email, forKey: "email")
    }
    
    func getUserEmail() -> String {
        if let email = UserDefaults.standard.string(forKey: "email") {
            return email
        }
        return "email"
    }
    
    // MARK: Save password to keychain
    func savePasswordToKeychain(password: String) {
        KeychainWrapper.standard.set(password, forKey: "userPassword")
    }
    
    // MARK: Get password from keychain for current user
    func getPasswordFromKeyChain() -> String {
        return KeychainWrapper.standard.string(forKey: "userPassword") ?? ""
    }
    
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
    
    func getUserProfilePhoto() -> Data? {
        guard let data = UserDefaults.standard.data(forKey: "encodedProfilePhoto") else {return nil}
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
//        let image = UIImage(data: decoded)
        return decoded
    }
    
    // MARK: Save and get to/from userDefaults info building location.
    func saveUserLivingAddress(address: String) {
        UserDefaults.standard.set(address, forKey: "userLivingAddress")
    }

    func getUserLivingAddress() -> String {
        if let venueAddress = UserDefaults.standard.string(forKey: "userLivingAddress") {
            return venueAddress
        }
        return "userLivingAddress"
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
    
    // MARK: Save and get to/from userDefaults info about supplier stage name.
    func saveSupplierStageName(stageName: String) {
        UserDefaults.standard.set(stageName, forKey: "stageName")
    }
    
    func getSupplierStageName() -> String? {
        if let supplierStageName = UserDefaults.standard.string(forKey: "stageName") {
            return supplierStageName
        }
        return nil
    }
    
    // MARK: Save and get to/from userDefaults info about supplier professional first skill.
    func saveSupplierFirstSkill(supplierFirstSkill: String) {
        UserDefaults.standard.set(supplierFirstSkill, forKey: "SupplierFirstSkill")
    }
    
    func getSupplierFirstSkill() -> String {
        if let supplierFirstSkill = UserDefaults.standard.string(forKey: "SupplierFirstSkill") {
            return supplierFirstSkill
        }
        return "SupplierFirstSkill"
    }
    
    // MARK: Save and get to/from userDefaults info about supplier professional first skill experience.
    func saveSupplierFirstSkillExperience(supplierFirstSkillExperience: Int) {
        UserDefaults.standard.set(supplierFirstSkillExperience, forKey: "SupplierFirstSkillExperience")
    }
    
    func getSupplierFirstSkillExperience() -> Int {
        let supplierFirstSkillExperience = UserDefaults.standard.integer(forKey: "SupplierFirstSkillExperience")
        return supplierFirstSkillExperience
    }
    
    // MARK: Save and get to/from userDefaults info about supplier professional first skill experience measure.
    func saveSupplierFirstSkillExperienceMeasure(supplierFirstSkillExperienceMeasure: String) {
        UserDefaults.standard.set(supplierFirstSkillExperienceMeasure, forKey: "SupplierFirstSkillExperienceMeasure")
    }
    
    func getSupplierFirstSkillExperienceMeasure() -> String {
        if let supplierFirstSkillExperienceMeasure = UserDefaults.standard.string(forKey: "SupplierFirstSkillExperienceMeasure") {
            return supplierFirstSkillExperienceMeasure
        }
        return "SupplierFirstSkillExperienceMeasure"
    }
    
    // MARK: Save and get to/from userDefaults info about person role.
    func saveSupplierStoryAboutWork(storyAboutWork: String) {
        UserDefaults.standard.set(storyAboutWork, forKey: "supplierStoryAboutWork")
    }
    
    func getSupplierStoryAboutWork() -> String {
        if let storyAboutWork = UserDefaults.standard.string(forKey: "supplierStoryAboutWork") {
            return storyAboutWork
        }
        return "storyAboutWork"
    }
    
//    // MARK: Save and get to/from userDefaults supplier's photos from work.
//    func saveSupplierPhotosFromWork(workPhotosJpeg: [Data?]) {
//        var allEncoded: [Data] = []
//        for photo in workPhotosJpeg {
//            let encoded = try! PropertyListEncoder().encode(photo)
//            allEncoded.append(encoded)
//        }
//        UserDefaults.standard.set(allEncoded, forKey: "encodedWorkPhotos")
//    }
//    
//    func getSupplierPhotosFromWork() -> [Data?] {
//        guard let data = UserDefaults.standard.array(forKey: "encodedWorkPhotos") as? [Data] else {
//            return [nil]
//        }
////        var imagesArray: [UIImage] = []
////
////        for imageData in data {
////            if let image = UIImage(data: imageData) {
////                imagesArray.append(image)
////            }
////        }
//        return data
//    }
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
    
    // MARK: Save and get to/from userDefaults info about performer company name.
    func savePerformerCompanyName(companyName: String) {
        UserDefaults.standard.set(companyName, forKey: "companyName")
    }
    
    func getPerformerCompanyName() -> String? {
        if let companyName = UserDefaults.standard.string(forKey: "companyName") {
            return companyName
        }
        return nil
    }
    
    // MARK: Save and get to/from userDefaults info about performer position in company.
    func savePerformerPositionInCompany(position: String) {
        UserDefaults.standard.set(position, forKey: "position")
    }
    
    func getPerformerPositionInCompany() -> String? {
        if let position = UserDefaults.standard.string(forKey: "position") {
            return position
        }
        return nil
    }
    
    // MARK: - Userdefaults methods for venues

    // MARK: Save and get to/from userDefaults info building location.
    func saveVenueBuildingAddress(address: String) {
        UserDefaults.standard.set(address, forKey: "venueAddress")
    }

    func getVenueBuildingAddress() -> String {
        if let venueAddress = UserDefaults.standard.string(forKey: "venueAddress") {
            return venueAddress
        }
        return "venueAddress"
    }
    
    // MARK: Save and get to/from userDefaults building name.
    func saveVenueBuildingName(buildingName: String) {
        UserDefaults.standard.set(buildingName, forKey: "venueBuildingName")
    }

    func getVenueBuildingName() -> String {
        if let venueBuildingName = UserDefaults.standard.string(forKey: "venueBuildingName") {
            return venueBuildingName
        }
        return "venueBuildingName"
    }
    
    // MARK: Save and get to/from userDefaults info about person role.
    func saveVenuePlaceDescription(placeDescription: String) {
        UserDefaults.standard.set(placeDescription, forKey: "placeDescription")
    }
    
    func getVenuePlaceDescription() -> String {
        if let placeDescription = UserDefaults.standard.string(forKey: "placeDescription") {
            return placeDescription
        }
        return "placeDescription"
    }
    
//    // MARK: Save and get to/from userDefaults venue's photos from work.
//    func saveVenuePhotosOfThePlace(photosOfThePlaceJpeg: [Data?]) {
//        var allEncoded: [Data] = []
//        for photo in photosOfThePlaceJpeg {
//            let encoded = try! PropertyListEncoder().encode(photo)
//            allEncoded.append(encoded)
//        }
//        UserDefaults.standard.set(allEncoded, forKey: "encodedPhotosOfThePlace")
//    }
//    
//    func getVenuePhotosOfThePlace() -> [UIImage?] {
//        guard let data = UserDefaults.standard.array(forKey: "encodedPhotosOfThePlace") as? [Data] else {
//            return [nil]
//        }
//        var imagesArray: [UIImage] = []
//
//        for imageData in data {
//            if let image = UIImage(data: imageData) {
//                imagesArray.append(image)
//            }
//        }
//        return imagesArray
//    }
}
