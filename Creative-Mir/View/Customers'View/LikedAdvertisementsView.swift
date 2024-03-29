//
//  LikedAdvertisementsView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 15.03.2024.
//

import SwiftUI

struct LikedAdvertisementsView: View {
    @ObservedObject var viewModel:LikedAdvertisementsViewModel
    @State private var showSuppliersEmpty: Bool = true
    @State private var showVenuesEmpty: Bool = true
    @State private var showIdeasEmpty: Bool = true // change later

    var body: some View {
        VStack(alignment: .leading) {
            if showSuppliersEmpty && showVenuesEmpty && showIdeasEmpty {
                Spacer()
                Text("You don't have any favorite advertisements yet 😓")
                    .font(.custom("Manrope-Bold", size: 25))
                Spacer()
            } else {
                Text("Liked announcements")
                    .font(.custom("Manrope-Bold", size: 32))
                ScrollView {
                    VStack(alignment: .leading, spacing: 32)  {
                        ForEach(viewModel.likedSuppliers, id: \.id) {supplier in
                            SupplierCell(viewModel: ExploreSuplierViewModel(), supplier: supplier, advIndex: 0)
                        }
                        ForEach(viewModel.likedVenues, id: \.id) {venue in
                            VenueCell(viewModel: ExploreVenuesViewModel(), venue: venue, advIndex: 0)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.getLikedSuppliers(customerId: AuthService.shared.currentUser?.uid ?? "id") { res in
                switch res {
                case .success(_):
                    showSuppliersEmpty = false
                case .failure(_):
                    showSuppliersEmpty = true
                }
            }
            viewModel.getLikedVenues(customerId: AuthService.shared.currentUser?.uid ?? "id") { res in
                switch res {
                case .success(_):
                    showVenuesEmpty = false
                case .failure(_):
                    showVenuesEmpty = true
                }
            }
        }
    }
}

#Preview {
    LikedAdvertisementsView(viewModel: LikedAdvertisementsViewModel())
}
