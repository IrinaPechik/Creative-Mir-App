//
//  AddingBuildingLocationView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 03.03.2024.
//

import SwiftUI
import MapKit

struct AddingBuildingLocationView: View {
    @State private var showPlaceLookupSheet = false
    @State var returnedPlace = Place(mapItem: MKMapItem())
    @State private var presentNextView = false
    
    @State private var placeName: String = ""
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Add your first\n     location")
                    .font(.custom("Lora-Regular", size: 32))
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Place name").font(.custom("Marcellus-Regular", size: 15))
                        TextField("", text: $placeName)
                            .font(.custom("Lora-Regular", size: 18))
                            .frame(minHeight: 40) // Высота текстового поля
                            .overlay(
                                Rectangle().frame(height: 1),
                                alignment: .bottomLeading) // Нижняя линия
                            .foregroundColor(.black) // Цвет текста
                    }
                    .frame(width: 320) // Ширина текстового поля
                    .padding()

                    Button {
                        showPlaceLookupSheet.toggle()
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Place address").font(.custom("Marcellus-Regular", size: 15))
                            HStack {
                                Image(systemName: "magnifyingglass").foregroundColor(.black)
                                Text(returnedPlace.fullAddress.isEmpty ? "" : returnedPlace.fullAddress)
                                    .font(.custom("Lora-Regular", size: 18))
                                    .frame(minHeight: 40)
                            }
                            .overlay(
                                Rectangle().frame(width: 320, height: 1),
                                alignment: .bottomLeading) // Нижняя линия
                        }
                        .foregroundColor(.black) // Цвет текста
                        .padding()
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)

                NextButtonViewSecond(buttonText: "N E X T", isDisabled: returnedPlace.fullAddress.isEmpty || placeName.isEmpty) {
                    AuthService.shared.saveVenueBuildingAddress(address: returnedPlace.fullAddress)
                    AuthService.shared.saveVenueBuildingName(buildingName: placeName)
                    print(AuthService.shared.getVenueBuildingAddress())
                    print(AuthService.shared.getVenueBuildingName())
                    // Переход к следующей view
                    presentNextView.toggle()
                }
                .padding(.top, 100)
            }
            .navigationDestination(isPresented: $presentNextView) {
                UpploadPhotoFromWork().environmentObject(PhotoPickerViewModel())
            }
        }
        .fullScreenCover(isPresented: $showPlaceLookupSheet, content: {
            FullAddressLokupView(returnedPlace: $returnedPlace).environmentObject(LocationManager())
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
    AddingBuildingLocationView()
}
