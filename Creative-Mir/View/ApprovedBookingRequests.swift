//
//  ApprovedBookingRequests.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 06.04.2024.
//

import SwiftUI

struct ApprovedBookingRequests: View {
    @StateObject var viewModel: BookingRequestsViewModel

    var body: some View {
        VStack {
            if viewModel.approvedBookingRequests.isEmpty {
                Spacer()
                Text("You don't have approved bookings")
                    .font(.custom("Manrope-Bold", size: 25))
                Spacer()
            } else {
                List {
                    ForEach(viewModel.approvedBookingRequests, id: \.id) {booking in
                        CustomerBookingCell(booking: booking)
                        .padding()
                        .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 0, y: 6)
                    }
                }
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .onAppear {
            viewModel.getApprovedRequestsForPerformer(performerId: AuthService.shared.currentUser!.uid)
        }
    }
}
