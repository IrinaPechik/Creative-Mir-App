//
//  VenueCard.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 31.03.2024.
//

import SwiftUI

struct VenueCard: View {
    @Binding var venue: MWVenue
    @Binding var user: MWUser
    @State var uiImage: UIImage? = nil
    @State var placePhotos: [UIImage] = []
    @Binding var advIndex: Int
    @State private var showBookAlert: Bool = false
    @State var doesBookingExist: Bool = false
    @State var showBookButton: Bool = true

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
                                Text("\(user.name) \(user.surname)")
                                    .font(customFont: .PlayfairDisplayMedium, size: 30)
                                if venue.advertisements[advIndex].legalStatus == "company" {
                                    Text("\(venue.advertisements[advIndex].companyName ?? "") \(venue.advertisements[advIndex].companyPosition ?? "")")
                                        .font(customFont: .PlayfairDisplayMedium, size: 48)
                                }
                                Text(user.email)
                                    .font(customFont: .LoraRegular, size: 18)
                                Text(venue.advertisements[advIndex].locationAddress)
                                    .font(customFont: .LoraRegular, size: 18)
                            }
                            Spacer()
                        }
                    }
                    .padding(.leading)
                    Spacer()
                    ScrollView {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("About\nlocation:").font(customFont: .LoraRegular, size: 24)
                                    .padding(.trailing)
                                Text(venue.advertisements[advIndex].locationDescription)
                                    .font(customFont: .OpenSansLight, size: 16)
                                Spacer()
                            }
                            .padding()
                            
                            ScrollView {
                                HStack {
                                    Text("Place\nphotos:").font(customFont: .LoraRegular, size: 24)
                                        .padding(.trailing)
                                    ForEach(placePhotos, id: \.self) { photo in
                                        Image(uiImage: photo)
                                            .resizable()
                                            .frame(width: 110, height: 110)
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .ignoresSafeArea(edges: .bottom)
                    if AuthService.shared.getUserRole() == "customer" && showBookButton && !doesBookingExist{
                        Button(action: {
                            showBookAlert = true
                        }, label: {
                            Text("Book")
                                .font(customFont: .PlayfairDisplayMedium, size: 30)
                                .foregroundStyle(.black)
                        })
                        .frame(width: 200, height: 50)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else if doesBookingExist {
                        Text("Booked")
                            .font(customFont: .PlayfairDisplayMedium, size: 30)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .sheet(isPresented: $showBookAlert) {
            withAnimation {
                BookField(performerId: venue.id, showBookAlert: $showBookAlert, doesBookingExist: $doesBookingExist)
            }
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
            
            StorageService.shared.downloadVenuesPhotoFromWorkImages(id: venue.id) { result in
                switch result {
                case .success(let data):
                    for photo in data {
                        if let img = UIImage(data: photo) {
                            placePhotos.append(img)
                        }
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            DatabaseService.shared.doesBookingExists(customerId: AuthService.shared.currentUser!.uid, performerId: venue.id) { result in
                switch result {
                case .success(let success):
                    doesBookingExist = success
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    VenueCard(venue: .constant(MWVenue(id: "45iixJ9bz2bAcsVl4xIQlcoivSo1", advertisements: [VenueAdvertisemnt(legalStatus: "individual", locationAddress: "East London", locationName: "Vibes Ville Venue", locationDescription: "the best")])), user: .constant(MWUser(id: "id", email: "email", name: "name", surname: "surname", birthday: "birthday", residentialAddress: "residentialAddress", role: "residentialAddress")), advIndex: .constant(0))
}
