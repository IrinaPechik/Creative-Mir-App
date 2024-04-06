//
//  SupplierBookCard.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 06.04.2024.
//

import SwiftUI

struct SupplierBookCard: View {
    @State var advIndex: Int = 0
    @Binding var booking: MWBooking
    @Binding var supplier: MWSupplier
    @Binding var user: MWUser
    @State var uiImage: UIImage? = nil
    @State var presentSupplierCard: Bool = false
    var body: some View {
        VStack {
            if let uiImage = uiImage {
                Spacer()
                VStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(supplier.advertisements[advIndex].skill)
                            .font(customFont: .PlayfairDisplayMedium, size: 48)
                        HStack {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 138, height: 138)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 20))

                            VStack(alignment: .leading) {
                                HStack {
                                    if supplier.advertisements[advIndex].legalStatus == "individual" {
                                        if supplier.advertisements[advIndex].stageName == nil {
                                            Text("\(user.name) \(user.surname)")
                                                .font(customFont: .PlayfairDisplayMedium, size: 30)
                                        } else {
                                            Text("\(supplier.advertisements[advIndex].stageName!)")
                                        }
                                    } else {
                                        Text("\(supplier.advertisements[advIndex].companyName!), \(supplier.advertisements[advIndex].companyPosition!)")
                                            .font(customFont: .PlayfairDisplayMedium, size: 30)
                                    }
                                    Image(systemName: "ellipsis.circle")
                                        .foregroundStyle(.black)
                                        .onTapGesture {
                                            presentSupplierCard = true
                                        }
                                }
                                Text(user.residentialAddress)
                                    .font(customFont: .LoraRegular, size: 18)
                                Text("\(supplier.advertisements[advIndex].experience) \(supplier.advertisements[advIndex].experienceMeasure) of experience")
                                    .font(customFont: .LoraRegular, size: 18)
                                Text(user.email)
                                    .font(customFont: .LoraRegular, size: 18)
                            }
                            Spacer()
                        }
                        .padding(.bottom)
                        Text("Booking details: ")
                            .font(customFont: .ManropeBold, size: 25)
                                .padding(.trailing)
                        HStack {
                            Text("Booking status: ").font(customFont: .ManropeBold, size: 18)
                                .padding(.trailing)
                            if booking.bookingStatus.lowercased() == "sent" {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 90, height: 30)
                                        .foregroundStyle(.yellow)
                                        .opacity(0.1)
                                    Text(booking.bookingStatus)
                                        .font(customFont: .ManropeBold, size: 16)
                                        .foregroundStyle(.black)
                                        .opacity(0.8)
                                }
                            } else if booking.bookingStatus.lowercased() == "approved" {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 90, height: 30)
                                        .foregroundStyle(.green)
                                        .opacity(0.1)
                                    Text(booking.bookingStatus)
                                        .font(customFont: .ManropeBold, size: 16)
                                        .foregroundStyle(.black)
                                        .opacity(0.8)
                                }
                            } else if booking.bookingStatus.lowercased() == "rejected" {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: 90, height: 30)
                                        .foregroundStyle(.red)
                                        .opacity(0.1)
                                    Text(booking.bookingStatus)
                                        .font(customFont: .ManropeBold, size: 16)
                                        .foregroundStyle(.black)
                                        .opacity(0.8)
                                }
                            }
                        }
                        .padding(.bottom)
                        Text("My book message: ")
                            .font(customFont: .ManropeBold, size: 18)
                            .padding(.trailing)
                        Text(booking.customerMessage)
                            .font(customFont: .LoraRegular, size: 16)
                        Spacer()
                    }
                    .padding(.leading)
                    Spacer()
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .sheet(isPresented: $presentSupplierCard) {
            SupplierCard(supplier: $supplier, user: $user, advIndex: $advIndex)
        }
        .onAppear {
            StorageService.shared.downloadUserAvatarImage(id: supplier.id) { result in
                switch result {
                case .success(let data):
                    if let img = UIImage(data: data) {
                        uiImage = img
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//#Preview {
//    SupplierBookCard(booking: <#Binding<MWBooking>#>, supplier: <#Binding<MWSupplier>#>, user: <#Binding<MWUser>#>)
//}
