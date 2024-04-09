//
//  CustomerBookingCell.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 06.04.2024.
//

import SwiftUI

struct CustomerBookingCell: View {
    @State var uiImage: UIImage? = nil
    @State var user: MWUser = MWUser(id: "id", email: "email", name: "name", surname: "surname", birthday: "birthday", residentialAddress: "adress", role: "role")
    @State var booking: MWBooking = MWBooking(id: "1", customerId: "2", performerId: "3", bookingStatus: "sended", customerMessage: "fff")

    var body: some View {
        VStack(alignment: .leading) {
            if let uiImage = uiImage {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 92, height: 92)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .firstTextBaseline) {
                                Text("\(user.name)")
                                    .font(customFont: .PlayfairDisplayMedium, size: 25)
                                Spacer()
                                if booking.bookingStatus.lowercased() == "sent" {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 90, height: 30)
                                            .foregroundStyle(.yellow)
                                            .opacity(0.1)
                                        Text(booking.bookingStatus)
                                            .font(customFont: .ManropeBold, size: 14)
                                            .foregroundStyle(.black)
                                            .opacity(0.8)
                                    }
                                } else if booking.bookingStatus.lowercased() == "approved" {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 90, height: 30)
                                            .foregroundStyle(.green)
                                            .opacity(0.1)
                                        Text(booking.bookingStatus)
                                            .font(customFont: .ManropeBold, size: 14)
                                            .foregroundStyle(.black)
                                            .opacity(0.8)
                                    }
                                } else if booking.bookingStatus.lowercased() == "rejected" {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 90, height: 30)
                                            .foregroundStyle(.red)
                                            .opacity(0.1)
                                        Text(booking.bookingStatus)
                                            .font(customFont: .ManropeBold, size: 14)
                                            .foregroundStyle(.black)
                                            .opacity(0.8)
                                    }
                                }
                            }
                            Text("\(user.surname)")
                                .font(customFont: .PlayfairDisplayMedium, size: 25)
//                            Spacer()
                            Text(user.email)
                                .font(customFont: .LoraMedium, size: 15)
                                .opacity(0.5)
                            Text(user.residentialAddress)
                                .font(customFont: .LoraMedium, size: 15)
                                .opacity(0.5)
                        }
                    }
                    .padding(.bottom)
                    Text(booking.customerMessage)
                        .font(customFont: .LoraMedium, size: 18)
                }
            }
        }
        .onAppear {
            DatabaseService.shared.getUser(id: booking.customerId) { userRes in
                switch userRes {
                case .success(let user):
                    self.user = user
                    StorageService.shared.downloadUserAvatarImage(id: user.id) { result in
                        switch result {
                        case .success(let data):
                            if let img = UIImage(data: data) {
                                uiImage = img
                            }
                        case.failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    CustomerBookingCell()
}
