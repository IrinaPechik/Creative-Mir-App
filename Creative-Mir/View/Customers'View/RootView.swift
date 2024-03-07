//
//  RootView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI

struct RootView: View {
    @State var selectedTab: Tabs = .home
    @State private var selectedPage: TopBars = .generateIdeas

    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == .home {
                    TopBar(selectedTopBar: $selectedPage)
                        .frame(height: 80)
                    if selectedPage == .generateIdeas {
//                        Spacer()
                        IdeasView()
//                        Spacer()
                    } else if selectedPage == .exploreSuppliers {
                        Spacer()
                        Text("ideas")
                        Spacer()
                    } else if selectedPage == .exploreVenues {
                        Spacer()
                        Text("ideas")
                        Spacer()
                    }
//                    CustomerFunctionsPickerView()
                } else if selectedTab == .star {
                    StarView()
                } else if selectedTab == .message {
                    MessageView()
                } else if selectedTab == .profile {
                    ProfileView()
                }
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    RootView()
}

struct MessageView: View {
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            Text("Message Tab")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
    }
}

struct StarView: View {
    var body: some View {
        ZStack {
            Color.pink.ignoresSafeArea()
            Text("Star Tab")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color.orange.ignoresSafeArea()
            Text("Profile Tab")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
    }
}
