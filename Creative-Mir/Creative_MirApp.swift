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
                HomeView()
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
            return true
        }
    }
}
