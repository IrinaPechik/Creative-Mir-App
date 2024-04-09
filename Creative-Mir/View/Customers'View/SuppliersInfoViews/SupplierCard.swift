//
//  SupplierCard.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 16.03.2024.
//

import SwiftUI

struct SupplierCard: View {
    @Binding var supplier: MWSupplier
    @Binding var user: MWUser
    @State var uiImage: UIImage? = nil
    @State var photosFromWork: [UIImage] = []
    @Binding var advIndex: Int
    
    @State private var showBookAlert: Bool = false
    @State var showBookButton: Bool = true
    @State var showBookMessage: Bool = false
    @State var bookMessage: String = ""
    @State var bookStatus: String = ""
    @State var doesBookingExist: Bool = false
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
                                Text(user.residentialAddress)
                                    .font(customFont: .LoraRegular, size: 18)
                                Text("\(supplier.advertisements[advIndex].experience) \(supplier.advertisements[advIndex].experienceMeasure) of experience")
                                    .font(customFont: .LoraRegular, size: 18)
                                Text(user.email)
                                    .font(customFont: .LoraRegular, size: 18)
                            }
                            Spacer()
                        }
                    }
                    .padding(.leading)
                    Spacer()
                        ScrollView {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("About me:").font(customFont: .LoraRegular, size: 24)
                                        .padding(.trailing)
                                    Text(supplier.storyAboutYourself)
                                        .font(customFont: .OpenSansLight, size: 16)
                                    Spacer()
                                }
                                .padding()
                                HStack {
                                    Text("About my\n career:").font(customFont: .LoraRegular, size: 24)
                                        .padding(.trailing)
                                    Text(supplier.storyAboutYourself)
                                        .font(customFont: .OpenSansLight, size: 16)
                                    Spacer()
                                }
                                .padding()
                                
//                                ScrollView {
                                    HStack {
                                        Text("My work\n photos:").font(customFont: .LoraRegular, size: 24)
                                            .padding(.trailing)
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(photosFromWork, id: \.self) { photo in
                                                    Image(uiImage: photo)
                                                        .resizable()
                                                        .frame(width: 110, height: 110)
                                                        .aspectRatio(contentMode: .fit)
                                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                                }
                                            }
                                        }
                                        .scrollIndicators(.hidden)
                                    }
//                                }
                                .padding()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .ignoresSafeArea(edges: .bottom)
                    if AuthService.shared.getUserRole() == "customer" && showBookButton && !doesBookingExist {
                        Button(action: {
                            showBookAlert = true
                        }, label: {
                            Text("Book")
                                .font(customFont: .PlayfairDisplayMedium, size: 30)
                                .foregroundStyle(.black)
                        })
                        .frame(width: 200, height: 50)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else if doesBookingExist {
                        Text("Booked")
                            .font(customFont: .PlayfairDisplayMedium, size: 30)
                            .foregroundStyle(.black)
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .sheet(isPresented: $showBookAlert) {
            withAnimation {
                BookField(performerId: supplier.id, showBookAlert: $showBookAlert, doesBookingExist: $doesBookingExist)
            }
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
            
            StorageService.shared.downloadSuppliersPhotoFromWorkImages(id: supplier.id) { result in
                switch result {
                case .success(let data):
                    for photo in data {
                        if let img = UIImage(data: photo) {
                            photosFromWork.append(img)
                        }
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            DatabaseService.shared.doesBookingExists(customerId: AuthService.shared.currentUser!.uid, performerId: supplier.id) { result in
                switch result {
                case .success(let success):
                    doesBookingExist = success
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func submit() {
        print("You entered")
    }
}

#Preview {
    SupplierCard(supplier: .constant(MWSupplier(id: "BU7G1DeIskbftR05qMc5jL0uIZf2", storyAboutYourself: "Music isn't just my job; it's my lifeblood. From the moment the music starts playing, I feel alive, and I want nothing more than to share that feeling with everyone around me. My sets are more than just a collection of songs; they're stories waiting to be told, emotions waiting to be felt. When I see the crowd moving and feeling the music as deeply as I do, it's like pure magic. That's what being a DJ means to me - spreading joy, energy, and love through the power of music.", advertisements: [SupplierAdvertisemnt(legalStatus: "individual", skill: "DJ", experience: 3, experienceMeasure: "years", storyAboutWork: "I'm Anna, a DJ bursting with passion and energy. When I step behind the decks, it's like stepping into a world where music becomes magic. With every beat I drop, I aim to take my audience on a thrilling journey filled with rhythm and emotion.")])), user: .constant(MWUser(id: "BU7G1DeIskbftR05qMc5jL0uIZf2", email: "anna@gmail.com", name: "Anne", surname: "Daniel", birthday: "31.12.1998", residentialAddress: "Cotati, United States", role: "supplier")), photosFromWork: [], advIndex: .constant(0))
}
