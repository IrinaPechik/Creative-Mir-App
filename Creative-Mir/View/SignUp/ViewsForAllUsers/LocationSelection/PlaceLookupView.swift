//
//  PlaceLookupView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 22.02.2024.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = PlaceViewModel()
    @State private var searchText = ""
    @Environment (\.dismiss) private var dismiss
    @Binding var returnedPlace: Place
    

    var body: some View {
        NavigationStack {
            List(placeVM.places) { place in
                VStack(alignment: .leading) {
                    Text(place.address)
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
            .onChange(of: searchText, perform: {text in
                if !text.isEmpty {
                    placeVM.search(text: text, region: locationManager.region)
                } else {
                    placeVM.places = []
                }
            })
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
    PlaceLookupView(returnedPlace: .constant(Place(mapItem: MKMapItem()))).environmentObject(LocationManager())
}
