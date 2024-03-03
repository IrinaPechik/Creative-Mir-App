//
//  AdressSelectionView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 31.01.2024.
//

import SwiftUI
import MapKit

struct AdressSelectionView: View {
    @State private var showPlaceLookupSheet = false
    @State var returnedPlace = Place(mapItem: MKMapItem())
    @State private var presentNextView = false
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("You live in")
                    .font(.custom("Lora-Regular", size: 32))
                    .padding(.bottom, 140)
                VStack(alignment: .leading, spacing: 10) {
                    Button {
                        showPlaceLookupSheet.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(.black)
                            Text(returnedPlace.address.isEmpty ? "Enter your city" : returnedPlace.address)
                                .font(.custom("Lora-Regular", size: 18))
                                .foregroundStyle(.black)
                        }
                    }
                    Rectangle().frame(width: 300, height: 1)
                }.padding(.bottom, 50)



                NextButtonViewSecond(buttonText: "N E X T", isDisabled: returnedPlace.address.isEmpty) {
                    AuthService.shared.saveUserLivingAddress(address: returnedPlace.address)
                    print(AuthService.shared.getUserLivingAddress())
                    // Переход к следующей view
                    presentNextView.toggle()
                }
                .padding(.top, 100)
            }
            .navigationDestination(isPresented: $presentNextView) {
                SelectingProfilePhotoView().environmentObject(PhotoPickerViewModel())
            }
        }
        .fullScreenCover(isPresented: $showPlaceLookupSheet, content: {
            PlaceLookupView(returnedPlace: $returnedPlace).environmentObject(LocationManager())
        })
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                PageCounter(currentCounter: 4, allPagesCount: 5)
            }
        }
    }
}

#Preview {
    AdressSelectionView().environmentObject(LocationManager())
}

