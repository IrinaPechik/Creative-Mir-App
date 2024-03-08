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
    // Очистка всех сохраненных данных из UserDefaults
    
    var body: some Scene {
        WindowGroup {
//            RoleChoosingView()
//            SignInView()
            // Очистка всех сохраненных данных из UserDefaults
            if AuthService.shared.isUserAuthenticated() {

//                HomeView()
//                IdeasView(viewModel: IdeasViewModel())
                RootView()
            } else {
                SignInView()
            }
        }
    }
    
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            // Очистка всех сохраненных данных из UserDefaults
            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
            }
            FirebaseApp.configure()
//            let idea = MWIdea(id: "1",
//                              name: "My Idea",
//                              image: "imageData", // Ваша строка с данными изображения
//                              description: "Description of my idea",
//                              shortDescription: "Short description",
//                              eventType: "Some Event",
//                              ageRestriction: 18,
//                              venuesRecommendations: "Recommendations for venues",
//                              suppliersRecommendations: "Recommendations for suppliers",
//                              peopleLimit: 100,
//                              colorScheme: "Blue")
//            DatabaseService.shared.setIdea(idea: idea) { res in
//                switch res {
//                case .success(_):
//                    print("fail")
//                case .failure(_):
//                    print("ok")
//                }
//            }
            
//            let category = [MWIdeaCategory(id: "1", categoryName: "Birthday", image: ""), MWIdeaCategory(id: "2", categoryName: "Wedding", image: ""), MWIdeaCategory(id: "3", categoryName: "Women's Day", image: "")]
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
