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
            VStack(alignment: .center, spacing: 40) {
                Text("You live in")
                    .font(.custom("Lora-Regular", size: 32))
                    .padding()
                
                Button {
                    showPlaceLookupSheet.toggle()
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "magnifyingglass").foregroundColor(.black)

                        Text(returnedPlace.address.isEmpty ? " Select your city        " : returnedPlace.address)
                            .font(.custom("Lora-Regular", size: 20))
                            .frame(height: 35) // Высота текстового поля
                            .padding(.trailing, 10)
                    }
                    .overlay(
                        Rectangle().frame(height: 1),
                        alignment: .bottomLeading) // Нижняя линия
                    .foregroundColor(.black) // Цвет текста
                }
                .padding(.top, 40)
                

                NextButtonViewSecond(isDisabled: returnedPlace.address.isEmpty) {
                    // Переход к следующей view
                    presentNextView.toggle()
                }
                .padding(.top, 100)
            }
            .navigationDestination(isPresented: $presentNextView) {
               Text("Photo")
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
                PageCounter(currentCounter: 4)
            }
        }
    }
}

#Preview {
    AdressSelectionView().environmentObject(LocationManager())
}

