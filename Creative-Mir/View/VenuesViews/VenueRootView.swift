//
//  VenueRootView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 02.04.2024.
//

import SwiftUI

struct VenueRootView: View {
    @State var selectedTab: PerformerTabs = .profile
    @State private var presentNextView: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == .profile {
                    VenueProfileView()
                    Spacer()
                } else if selectedTab == .bookingRequests {
//                    Text("booking requests")
                    BookingRequests(viewModel: BookingRequestsViewModel())
                    Spacer()
                } else {
                    ApprovedBookingRequests(viewModel: BookingRequestsViewModel())
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
    VenueRootView()
}
