//
//  VenueBookCard.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 06.04.2024.
//

import SwiftUI

struct VenueBookCard: View {
    @State var advIndex: Int = 0
    @Binding var booking: MWBooking
    @Binding var venue: MWVenue
    @Binding var user: MWUser
    @State var uiImage: UIImage? = nil
    @State var presentVenueCard: Bool = false
    
    var body: some View {
        VStack {
            if let uiImage = uiImage {
                Spacer()
                VStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(venue.advertisements[advIndex].locationName)
                            .font(customFont: .PlayfairDisplayMedium, size: 48)
                        HStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 138, height: 138)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(user.name) \(user.surname)")
                                        .font(customFont: .PlayfairDisplayMedium, size: 30)
                                    Image(systemName: "ellipsis.circle")
                                        .foregroundStyle(.black)
                                        .onTapGesture {
                                            presentVenueCard = true
                                        }
                                }
                                if venue.advertisements[advIndex].legalStatus == "company" {
                                    Text("\(venue.advertisements[advIndex].companyName ?? "") \(venue.advertisements[advIndex].companyPosition ?? "")")
                                        .font(customFont: .PlayfairDisplayMedium, size: 48)
                                }
                                Text(user.email)
                                    .font(customFont: .LoraRegular, size: 18)
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom)
                        Text("Booking details: ")
                            .font(customFont: .ManropeBold, size: 25)
                                .padding(.trailing)
                        HStack {
                            Text("Booking status: ").font(customFont: .ManropeBold, size: 18)
                                .padding(.trailing)
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
                        }
                        .padding(.bottom)
                        Text("My book message: ")
                            .font(customFont: .ManropeBold, size: 18)
                            .padding(.trailing)
                        Text(booking.customerMessage)
                            .font(customFont: .LoraRegular, size: 16)
                        Spacer()
                    }
                    .padding(.leading)
                    Spacer()

                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .sheet(isPresented: $presentVenueCard) {
            VenueCard(venue: $venue, user: $user, advIndex: $advIndex)
        }
        .onAppear {
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
        }
    }
}

