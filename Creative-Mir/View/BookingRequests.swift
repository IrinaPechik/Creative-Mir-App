//
//  BookingRequests.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 02.04.2024.
//

import SwiftUI

struct BookingRequests: View {
    @StateObject var viewModel: BookingRequestsViewModel
    
    var body: some View {
        VStack {
            if viewModel.allRequestsForBooking.isEmpty {
                Spacer()
                Text("You don't have bookings")
                    .font(.custom("Manrope-Bold", size: 25))
                Spacer()
            } else {
                List {
                    ForEach(viewModel.allRequestsForBooking, id: \.id) {booking in
                        CustomerBookingCell(booking: booking)
                        .padding()
                        .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 0, y: 6)
                        .swipeActions {
                            Button(role: .destructive) {
                                DatabaseService.shared.updateBookingStatus(bookingId: booking.id, newStatus: "rejected") { error in
                                    if let error = error {
                                        print("Failed to update booking status: \(error.localizedDescription)")
                                    } else {
                                        print("Booking status updated successfully")
                                    }
                                }
                                // удаляется
                            } label: {
                                Label("Reject", systemImage: "xmark.seal")
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                // approved удаляется отсюда, но добавляется в одобренные
                                DatabaseService.shared.updateBookingStatus(bookingId: booking.id, newStatus: "approved") { error in
                                    if let error = error {
                                        print("Failed to update booking status: \(error.localizedDescription)")
                                    } else {
                                        print("Booking status updated successfully")
                                    }
                                }
                            } label: {
                                Label("Approve", systemImage: "checkmark.seal")
                            }
                            .tint(.green)
                        }
                    }
                }
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .onAppear {
            viewModel.getSendedRequestsForPerformer(performerId: AuthService.shared.currentUser!.uid)
        }
    }
    
}

#Preview {
    BookingRequests(viewModel: BookingRequestsViewModel())
}
