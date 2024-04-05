//
//  CustomTabBar.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI

enum CustomerTabs: Int {
    case home = 0
    case likedAdvertisements = 1
    case likedIdeas = 2
    case profile = 3
}

struct CustomerTabBar: View {
    @Binding var selectedTab: CustomerTabs
    
    var body: some View {
        HStack(alignment: .center, spacing: 60) {
            Button {
                selectedTab = .home
            } label: {
                Image(systemName: "house")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .tint(selectedTab == .home ? .black : .gray)
            
            Button {
                selectedTab = .likedAdvertisements
            } label: {
                Image(systemName: "suit.heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .tint(selectedTab == .likedAdvertisements ? .black : .gray)
            
            Button {
                selectedTab = .likedIdeas
            } label: {
                Image(systemName: "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .tint(selectedTab == .likedIdeas ? .black : .gray)
            
            Button {
                selectedTab = .profile
            } label: {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .tint(selectedTab == .profile ? .black : .gray)
        }
    }
}

#Preview {
    CustomerTabBar(selectedTab: .constant(.home))
}
