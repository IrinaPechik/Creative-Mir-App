//
//  SupplierBookCell.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 06.04.2024.
//

import SwiftUI

struct SupplierBookCell: View {
    @State var booking: MWBooking = MWBooking(id: "1", customerId: "2", performerId: "3", bookingStatus: "sended", customerMessage: "fff")
    @State var supplier: MWSupplier = MWSupplier(id: "id")
    @State var user: MWUser = MWUser(id: "id", email: "email", name: "name", surname: "surname", birthday: "birthday", residentialAddress: "adress", role: "role")
    @State var advIndex: Int = 0
    @State var uiImage: UIImage? = nil
    @State var presentSupplierInfo: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            if let uiImage = uiImage {
                HStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 92, height: 92)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack(alignment: .leading) {
                        Text(supplier.advertisements[advIndex].skill)
                            .font(.custom("Manrope-Bold", size: 20))
                        if supplier.advertisements[advIndex].legalStatus == "company" {
                            Text("\(supplier.advertisements[advIndex].companyName!), \(supplier.advertisements[advIndex].companyPosition!)")
                                .font(.custom("Manrope-Bold", size: 16))
                                .opacity(0.5)
                        } else {
                            if supplier.advertisements[advIndex].stageName == nil {
                                Text("\(user.name) \(user.surname)")
                                    .font(.custom("Manrope-Bold", size: 16))
                                    .opacity(0.5)
                            } else {
                                Text("\(supplier.advertisements[advIndex].stageName!)")
                                    .font(.custom("Manrope-Bold", size: 16))
                                    .opacity(0.5)
                            }
                        }
                        Text("\(supplier.advertisements[advIndex].experience) \(supplier.advertisements[advIndex].experienceMeasure) of experience")
                            .font(.custom("Manrope-Medium", size: 15))
                            .opacity(0.5)
                    }
                    Spacer()
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
                    Spacer()
                }
            }
        }
        .frame(width: 380, height: 100)
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 3, y: 3)
        .onTapGesture {
            presentSupplierInfo = true
        }
        .sheet(isPresented: $presentSupplierInfo) {
            SupplierBookCard(booking: $booking, supplier: $supplier, user: $user)
        }
        .onAppear {
            DatabaseService.shared.getSupplier(id: booking.performerId) { supplierRes in
                switch supplierRes {
                case .success(let supplier):
                    self.supplier = supplier
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
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            DatabaseService.shared.getUser(id: booking.performerId) { userRes in
                switch userRes {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//#Preview {
//    SupplierBookCell(bookingViewModel: CustomerBookViewModel(), supplier: MWSupplier(id: "6Ij6cvVzB2acMnWAiWMinxeWQHy2"))
//}
