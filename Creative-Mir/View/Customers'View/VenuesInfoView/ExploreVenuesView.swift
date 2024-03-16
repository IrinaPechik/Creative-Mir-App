//
//  ExploreVenuesView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 16.03.2024.
//

import SwiftUI

struct ExploreVenuesView: View {
    @StateObject var viewModel: ExploreVenuesViewModel
    @State private var showEmptyError: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            if showEmptyError {
                Text("There are no registered venues yet 😓")
                    .font(.custom("Manrope-Bold", size: 27))
                    .frame(width: 320)
            } else {
                Text("Explore Suppliers")
                    .font(.custom("Manrope-Bold", size: 32))
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(viewModel.venues, id: \.id) { venue in
                            ForEach(venue.advertisements.indices, id: \.self) { advInd in
                                VenueCell(viewModel: ExploreVenuesViewModel(), venue: venue, advIndex: advInd)
                            }
                        }
                    }
                    .frame(width: 390)
                }
                .frame(width: 390)
            }
        }
        .onAppear {
            self.viewModel.getVenues() { res in
                switch res {
                case .success(_):
                    showEmptyError = false
                case .failure(_):
                    showEmptyError = true
                }
            }
        }
    }
}

#Preview {
    ExploreVenuesView(viewModel: ExploreVenuesViewModel())
}
