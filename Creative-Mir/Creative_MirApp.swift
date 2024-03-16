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
                    SupplierProfileView()
                } else {
                    VenueProfileView()
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
//            let defaults = UserDefaults.standard
//            let dictionary = defaults.dictionaryRepresentation()
//
//            dictionary.keys.forEach { key in
//                defaults.removeObject(forKey: key)
//            }
//            FirebaseApp.configure()
            
            
            
//            let image = UIImage(named: "puppyPawty")
//            let imageData = image?.jpegData(compressionQuality: 0.5)
//            
//            StorageService.shared.uploadIdeaImage(ideaId: "7", image: imageData!) { result in
//                switch result {
//                case .success(let sizeInfo):
//                    print(sizeInfo)
//                case .failure(let error):
//                    print("error \(error)")
//                }
//            }

            
//            let idea = MWIdea(id: "7",
//                              categoryId: "4",
//                              name: "Puppy Pawty",
//                              description: "Get ready to wag your tails and bark with delight at the \"Puppy Pawty\" – the ultimate celebration for our furry friends! Picture a whimsically decorated venue adorned paw-print banners, and doggy-themed decorations. Pups of all shapes and sizes prance around, sporting adorable party hats and wagging their tails with excitement. From a doggy fashion show showcasing the latest canine couture to a playful game of fetch and a \"best trick\" competition, there's no shortage of tail-wagging fun. As their humans mingle and share stories, four-legged guests indulge in delicious treats like pup-friendly birthday cake and refreshing bowls of water. With every woof and wiggle, it's evident that this Puppy Pawty is a barking success, leaving paw prints of joy on the hearts of all who attend.",
//                              shortDescription: "Unless the fun",
//                              ageRestriction: 0,
//                              venuesRecommendations: "Verve dog boutique",
//                              suppliersRecommendations: "merimeri",
//                              peopleLimit: 20,
//                              colorScheme: "Green")
//            DatabaseService.shared.setIdea(idea: idea) { res in
//                switch res {
//                case .success(_):
//                    print("fail")
//                case .failure(_):
//                    print("ok")
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
            
//            let category = [MWIdeaCategory(id: "4", categoryName: "Pet Birthday"), MWIdeaCategory(id: "2", categoryName: "Wedding", image: ""), MWIdeaCategory(id: "3", categoryName: "Women's Day", image: "")]
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

            return true
        }
    }
}
