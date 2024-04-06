//
//  CustomerBookingView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 06.04.2024.
//

import SwiftUI

struct CustomerBookingView: View {
    @StateObject var bookingViewModel: CustomerBookViewModel

    var body: some View {
        VStack {
            if bookingViewModel.suppliersBookings.isEmpty && bookingViewModel.venuesBookings.isEmpty  {
                Spacer()
                Text("You dont have bookings")
                    .font(.custom("Manrope-Bold", size: 25))
                Spacer()
            } else {
                Text("My Bookings:")
                    .font(.custom("Manrope-Bold", size: 32))
                    .padding()
                List {
                    ForEach(bookingViewModel.suppliersBookings, id: \.id) { booking in
//                        CustomerBookCell(booking: booking, role: "supplier", bookingViewModel: CustomerBookViewModel())
                        SupplierBookCell(booking: booking)
                            .padding()
                            .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 0, y: 6)
                            .swipeActions {
                                Button(role: .destructive) {
                                    DatabaseService.shared.deleteBooking(bookingId: booking.id) { error in
                                        if let error = error {
                                            print("Ошибка при удалении бронирования: \(error.localizedDescription)")
                                        } else {
                                            print("Бронирование успешно удалено")
                                        }
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                            .listSectionSeparator(.hidden)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    
                    
                    ForEach(bookingViewModel.venuesBookings, id: \.id) { booking in
                        VenueBookCell(booking: booking)
                            .padding()
                            .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 0, y: 6)
                            .swipeActions {
                                Button(role: .destructive) {
                                    DatabaseService.shared.deleteBooking(bookingId: booking.id) { error in
                                        if let error = error {
                                            print("Ошибка при удалении бронирования: \(error.localizedDescription)")
                                        } else {
                                            print("Бронирование успешно удалено")
                                        }
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                            .listSectionSeparator(.hidden)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            self.bookingViewModel.getCustomerBookings(customerId: AuthService.shared.currentUser!.uid)
        }
    }
}

#Preview {
    CustomerBookingView(bookingViewModel: CustomerBookViewModel())
}
