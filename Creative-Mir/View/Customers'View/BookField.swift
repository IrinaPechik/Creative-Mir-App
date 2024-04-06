//
//  BookField.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 02.04.2024.
//

import SwiftUI

struct BookField: View {
    @State private var wishes: String = ""
    @State var performerId: String
    @Binding var showBookAlert: Bool
    @Binding var doesBookingExist: Bool
    var body: some View {
        VStack {
            Text("Enter your booking requests")
                .font(customFont: .PlayfairDisplayMedium, size: 25)
            TextField("Write your wishes for booking", text: $wishes, axis: .vertical)
                .multilineTextAlignment(.leading)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding()
                .lineLimit(9...)
                .font(.custom("Lora-Regular", size: 18))
            NextButtonViewSecond(buttonText: "Send a request", isDisabled: wishes.isEmpty) {
                var booking = MWBooking(id: UUID().uuidString, customerId: AuthService.shared.getUserId(), performerId: performerId, bookingStatus: "Sent", customerMessage: wishes)
                DatabaseService.shared.setBooking(booking: booking) { res in
                    switch res {
                    case .success(_):
                        doesBookingExist = true
                        showBookAlert = false
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                // Отправление запроса
                showBookAlert = false
                print(1)
            }
        }
    }
}
//
//#Preview {
//    BookField(showBookAlert: .constant(true))
//}
