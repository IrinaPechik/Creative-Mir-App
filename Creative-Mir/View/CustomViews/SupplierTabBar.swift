//
//  SupplierTabBar.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 02.04.2024.
//

import SwiftUI

enum PerformerTabs: Int {
    case bookingRequests = 0
    case approvedBookingRequests = 1
    case profile = 2
}

struct SupplierTabBar: View {
    @Binding var selectedTab: PerformerTabs
    
    var body: some View {
        HStack(alignment: .center, spacing: 60) {
            Button {
                selectedTab = .bookingRequests
            } label: {
                Image(systemName: "bell.and.waves.left.and.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .tint(selectedTab == .bookingRequests ? .black : .gray)
            
            Button {
                selectedTab = .approvedBookingRequests
            } label: {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .tint(selectedTab == .approvedBookingRequests ? .black : .gray)
            
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
    SupplierTabBar(selectedTab: .constant(.bookingRequests))
}
