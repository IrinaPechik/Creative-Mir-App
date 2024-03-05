//
//  FullAddressLokupView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 03.03.2024.
//

import SwiftUI
import MapKit

struct FullAddressLokupView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = FullAddressViewModel()
    @State private var searchText = ""
    @Environment (\.dismiss) private var dismiss
    @Binding var returnedPlace: Place
    

    var body: some View {
        NavigationStack {
            List(placeVM.places) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.custom("Lora-Regular", size: 23))
                    Text(place.fullAddress)
                        .font(.custom("Lora-Regular", size: 20))
                }
                .onTapGesture {
                    returnedPlace = place
                    dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
                .font(.custom("Lora-Regular", size: 16))
            .onChange(of: searchText) {
                if !searchText.isEmpty {
                    placeVM.search(text: searchText, region: locationManager.region)
                } else {
                    placeVM.places = []
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .foregroundColor(.gray)

                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    FullAddressLokupView(returnedPlace: .constant(Place(mapItem: MKMapItem()))).environmentObject(LocationManager())
}
