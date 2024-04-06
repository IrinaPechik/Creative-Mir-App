//
//  VenueBookCell.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 06.04.2024.
//

import SwiftUI

struct VenueBookCell: View {
    @State var booking: MWBooking = MWBooking(id: "1", customerId: "2", performerId: "3", bookingStatus: "sended", customerMessage: "fff")
    @State var venue: MWVenue = MWVenue(id: "id")
    @State var user: MWUser = MWUser(id: "id", email: "email", name: "name", surname: "surname", birthday: "birthday", residentialAddress: "adress", role: "role")
    @State var advIndex: Int = 0
    @State var uiImage: UIImage? = nil
    @State var presentVenueInfo: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if let uiImage = uiImage {
                HStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 92, height: 92)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack(alignment: .leading) {
                        Text(venue.advertisements[advIndex].locationName)
                        if venue.advertisements[advIndex].legalStatus == "company" {
                            Text("\(venue.advertisements[advIndex].companyName!), \(venue.advertisements[advIndex].companyPosition!)")
                                .font(.custom("Manrope-Bold", size: 16))
                                .opacity(0.5)
                        } else {
                            Text("\(user.name) \(user.surname)")
                                .font(.custom("Manrope-Bold", size: 16))
                                .opacity(0.5)
                        }
                        Text("\(venue.advertisements[advIndex].locationAddress)")
                            .font(.custom("Manrope-Medium", size: 15))
                            .opacity(0.5)
                    }
                    Spacer()
                    if booking.bookingStatus.lowercased() == "sent" {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 90, height: 30)
                                .foregroundStyle(.yellow)
                                .opacity(0.1)
                            Text(booking.bookingStatus)
                                .font(customFont: .ManropeBold, size: 16)
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
                                .font(customFont: .ManropeBold, size: 16)
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
                                .font(customFont: .ManropeBold, size: 16)
                                .foregroundStyle(.black)
                                .opacity(0.8)
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(width: 380, height: 100)
        .background()
        .onTapGesture {
            presentVenueInfo = true
        }
        .sheet(isPresented: $presentVenueInfo) {
            VenueBookCard(booking: $booking, venue: $venue, user: $user)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 3, y: 3)
        .onAppear {
            DatabaseService.shared.getVenue(id: booking.performerId) { venueRes in
                switch venueRes {
                case .success(let venue):
                    self.venue = venue
                    StorageService.shared.downloadUserAvatarImage(id: venue.id) { result in
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
            DatabaseService.shared.getUser(id: venue.id) { result in
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    VenueBookCell()
}
