//
//  VenueCell.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 16.03.2024.
//

import SwiftUI

struct VenueCell: View {
    @StateObject var viewModel: ExploreVenuesViewModel

    @State var venue: MWVenue
    @State var advIndex: Int
    @State var uiImage: UIImage? = nil
    @State private var isLiked = false

    @State var user: MWUser = MWUser(id: "id", email: "email", name: "name", surname: "surname", birthday: "birthday", residentialAddress: "residentialAddress", role: "residentialAddress")
    
    @State var presentVenueInfo: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
//            if let user = user {
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
                            Image(systemName: "heart")
                                .font(.title2)
                                .foregroundColor(isLiked ? .black : Color(red: 191/255, green: 194/255, blue: 200/255))
                                .padding(10)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isLiked.toggle()
                                    }
                                    if isLiked {
                                        viewModel.addLikeToVenue(customerId: AuthService.shared.currentUser?.uid ?? "id", venue: self.venue)
                                    } else {
                                        viewModel.removeLikeFromVenue(customerId: AuthService.shared.currentUser?.uid ?? "id", venue: self.venue)
                                    }
                                }
                        }
                    }
//            }
        }
        .frame(width: 380, height: 100)
        .background()
        .onTapGesture {
            presentVenueInfo = true
        }
        .sheet(isPresented: $presentVenueInfo) {
            VenueCard(venue: $venue, user: $user, advIndex: $advIndex)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 3, y: 3)
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
            DatabaseService.shared.getUser(id: venue.id) { result in
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            DatabaseService.shared.checkWasVenueLikedById(customerId: AuthService.shared.currentUser?.uid ?? "id", venueId: venue.id) { res in
                switch res {
                case .success(let wasLiked):
                    isLiked = wasLiked
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    VenueCell(viewModel: ExploreVenuesViewModel(), venue: MWVenue(id: "1", advertisements: [VenueAdvertisemnt(legalStatus: "individual", locationAddress: "East London", locationName: "Vibes Ville Venue", locationDescription: "the best")]), advIndex: 0, user: MWUser(id: "id", email: "email", name: "name", surname: "surname", birthday: "birthday", residentialAddress: "residentialAddress", role: "residentialAddress"))
}
