//
//  SupplierRootView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 02.04.2024.
//

import SwiftUI

struct SupplierRootView: View {
    @State var selectedTab: PerformerTabs = .profile
    @State private var presentNextView: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == .profile {
                    SupplierProfileView()
                    Spacer()
                } else if selectedTab == .bookingRequests {
                    BookingRequests(viewModel: BookingRequestsViewModel())
//                    Text("booking requests")
                    Spacer()
                } else {
                    Text("approved booking requests")
                    Spacer()
                }
                SupplierTabBar(selectedTab: $selectedTab)
            }
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
        }
    }
}

#Preview {
    SupplierRootView()
}
