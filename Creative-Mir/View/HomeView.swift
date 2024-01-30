//
//  HomeView.swift
//  Creative-Mir
//
//  Created by Печик Дарья on 19.01.2024.
//

import SwiftUI

struct HomeView: View {
    enum ViewStack {
        case signIn
    }
    @State private var nextView: ViewStack = .signIn
    @State private var presentNextView: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Button("Log out") {
                    Task {
                        do {
                            try AuthService.shared.signOut()
                            presentNextView.toggle()
                            nextView = .signIn
                        } catch {
                            
                        }
                    }

                }
            }.fullScreenCover(isPresented: $presentNextView) {
                switch nextView {
                case .signIn:
                    SignInView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
