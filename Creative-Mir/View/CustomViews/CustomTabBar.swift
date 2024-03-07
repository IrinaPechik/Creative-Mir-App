//
//  CustomTabBar.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 07.03.2024.
//

import SwiftUI

enum Tabs: Int {
    case home = 0
    case star = 1
    case message = 2
    case profile = 3
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tabs
    
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
                selectedTab = .star
            } label: {
                Image(systemName: "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .tint(selectedTab == .star ? .black : .gray)
            
            Button {
                selectedTab = .message
            } label: {
                Image(systemName: "message")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .tint(selectedTab == .message ? .black : .gray)
            
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
//        .frame(height: 82)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home))
}
