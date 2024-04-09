//
//  LikedAdvertisementsView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 15.03.2024.
//

import SwiftUI

struct LikedAdvertisementsView: View {
    @ObservedObject var viewModel: LikedAdvertisementsViewModel
    
    @State private var showSuppliersEmpty: Bool = true
    @State private var showVenuesEmpty: Bool = true
    @State var isLoading: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if showSuppliersEmpty && showVenuesEmpty {
                Spacer()
                Text("You don't have any favorite advertisements yet 😓")
                    .font(.custom("Manrope-Bold", size: 25))
                Spacer()
            } else {
                Text("Liked announcements")
                    .font(.custom("Manrope-Bold", size: 32))
                    .padding()
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
                .scrollIndicators(.hidden)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isLoading = false
            }
        }
    }
}

#Preview {
    LikedAdvertisementsView(viewModel: LikedAdvertisementsViewModel())
}
