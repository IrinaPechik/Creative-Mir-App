//
//  Creative_MirApp.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 12.01.2024.
//

import SwiftUI
import Firebase
import SwiftKeychainWrapper

@main
struct Creative_MirApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @State private var isUserAuthenticated: Bool?
    @State private var showSignInView: Bool = false
    @State private var userRole: String = ""
    init() {
            for i in UIFont.familyNames {
                print(i)
                for fontName in UIFont.fontNames(forFamilyName: i) {
                    print("-- \(fontName)")
                }
            }
        }
    var body: some Scene {
        WindowGroup {
            if AuthService.shared.isUserAuthenticated(){
                let userRole = AuthService.shared.getUserRole()
                if userRole == "customer" {
                    RootView()
                } else if userRole == "supplier" {
                    SupplierRootView()
                } else {
                    VenueRootView()
                }
            } else {
                SignInView()
            }
        }
    }
    
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()

//             Очистка всех сохраненных данных из UserDefaults
//            do {
//                try AuthService.shared.signOut()
//            } catch {
//                print("Error while signOut")
//            }
//            if let bundleIdentifier = Bundle.main.bundleIdentifier {
//                UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
//            }
//            
//            
//            let defaults = UserDefaults.standard
//            let dictionary = defaults.dictionaryRepresentation()
//
//            dictionary.keys.forEach { key in
//                defaults.removeObject(forKey: key)
//            }
//            FirebaseApp.configure()
            
            

            
//            let idea = MWIdea(id: "4",
//                              categoryId: "6",
//                              name: "Upcycle Groove",
//                              description: "Welcome to \"Upcycle Groove\", where sustainability meets style in an eco-friendly celebration like no other. Immerse yourself in a world of creativity and conscious living as we redefine the art of partying with a focus on upcycling and sustainability.\nExperience a visual feast of upcycled decor, where discarded materials are transformed into stunning works of art. From reclaimed pallet furniture to vintage-inspired decorations, every element of the event reflects our commitment to sustainability.",
//                              shortDescription: "Sustainable Soiree",
//                              ageRestriction: 21,
//                              venuesRecommendations: "The Crystal",
//                              suppliersRecommendations: "Eco Props",
//                              peopleLimit: 60,
//                              colorScheme: "Black and beige")
//            DatabaseService.shared.setIdea(idea: idea) { res in
//                switch res {
//                case .success(_):
//                    print("fail")
//                case .failure(_):
//                    print("ok")
//                }
//            }
//            
//            let image = UIImage(named: "image3")
//            let imageData = image?.jpegData(compressionQuality: 0.5)
//
//            StorageService.shared.uploadIdeaImage(ideaId: "4", image: imageData!) { result in
//                switch result {
//                case .success(let sizeInfo):
//                    print(sizeInfo)
//                case .failure(let error):
//                    print("error \(error)")
//                }
//            }
//
//            let idea2 = MWIdea(id: "2",
//                              categoryId: "1",
//                              name: "Birthday Idea 2",
//                              image: "imageData", // Ваша строка с данными изображения
//                              description: "Description of my idea",
//                              shortDescription: "Short description",
//                              eventType: "Some Event",
//                              ageRestriction: 18,
//                              venuesRecommendations: "Recommendations for venues",
//                              suppliersRecommendations: "Recommendations for suppliers",
//                              peopleLimit: 100,
//                              colorScheme: "Blue")
//            DatabaseService.shared.setIdea(idea: idea2) { res in
//                switch res {
//                case .success(_):
//                    print("fail")
//                case .failure(_):
//                    print("ok")
//                }
//            }
//            
//            let idea3 = MWIdea(id: "3",
//                              categoryId: "2",
//                              name: "Wedding Idea 1",
//                              image: "imageData", // Ваша строка с данными изображения
//                              description: "Description of my idea",
//                              shortDescription: "Short description",
//                              eventType: "Some Event",
//                              ageRestriction: 18,
//                              venuesRecommendations: "Recommendations for venues",
//                              suppliersRecommendations: "Recommendations for suppliers",
//                              peopleLimit: 100,
//                              colorScheme: "Blue")
//            DatabaseService.shared.setIdea(idea: idea3) { res in
//                switch res {
//                case .success(_):
//                    print("fail")
//                case .failure(_):
//                    print("ok")
//                }
//            }
//            
//            let idea4 = MWIdea(id: "4",
//                              categoryId: "2",
//                              name: "Wedding Idea 2",
//                              image: "imageData", // Ваша строка с данными изображения
//                              description: "Description of my idea",
//                              shortDescription: "Short description",
//                              eventType: "Some Event",
//                              ageRestriction: 18,
//                              venuesRecommendations: "Recommendations for venues",
//                              suppliersRecommendations: "Recommendations for suppliers",
//                              peopleLimit: 100,
//                              colorScheme: "Blue")
//            DatabaseService.shared.setIdea(idea: idea4) { res in
//                switch res {
//                case .success(_):
//                    print("fail")
//                case .failure(_):
//                    print("ok")
//                }
//            }
//            
//            
//            let idea5 = MWIdea(id: "5",
//                              categoryId: "3",
//                              name: "womens day Idea 1",
//                              image: "imageData", // Ваша строка с данными изображения
//                              description: "Description of my idea",
//                              shortDescription: "Short description",
//                              eventType: "Some Event",
//                              ageRestriction: 18,
//                              venuesRecommendations: "Recommendations for venues",
//                              suppliersRecommendations: "Recommendations for suppliers",
//                              peopleLimit: 100,
//                              colorScheme: "Blue")
//            DatabaseService.shared.setIdea(idea: idea5) { res in
//                switch res {
//                case .success(_):
//                    print("fail")
//                case .failure(_):
//                    print("ok")
//                }
//            }
//            
//            let idea6 = MWIdea(id: "6",
//                              categoryId: "3",
//                              name: "womens day Idea 2",
//                              image: "imageData", // Ваша строка с данными изображения
//                              description: "Description of my idea",
//                              shortDescription: "Short description",
//                              eventType: "Some Event",
//                              ageRestriction: 18,
//                              venuesRecommendations: "Recommendations for venues",
//                              suppliersRecommendations: "Recommendations for suppliers",
//                              peopleLimit: 100,
//                              colorScheme: "Blue")
//            DatabaseService.shared.setIdea(idea: idea6) { res in
//                switch res {
//                case .success(_):
//                    print("fail")
//                case .failure(_):
//                    print("ok")
//                }
//            }
            
//            let category = [MWIdeaCategory(id: "6", categoryName: "Corporate party")]
//            for c in category {
//                DatabaseService.shared.setIdeaCategories(category: c) { result in
//                    switch result {
//                    case .success(_):
//                        print("fail")
//                    case .failure(_):
//                        print("ok")
//                    }
//                }
//            }
//
//            let image = UIImage(named: "image4")
//            let imageData = image?.jpegData(compressionQuality: 0.5)
//            
//            StorageService.shared.uploadIdeaCategoryImage(categoryId: "6", image: imageData!) { result in
//                switch result {
//                case .success(let sizeInfo):
//                    print(sizeInfo)
//                case .failure(let error):
//                    print("error \(error)")
//                }
//            }
            return true
        }
    }
}
