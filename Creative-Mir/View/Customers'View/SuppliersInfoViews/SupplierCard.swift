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
    @Binding var advIndex: Int
    var body: some View {
        VStack {
            if let uiImage = uiImage {
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
                            } else {
                                Text("\(supplier.advertisements[advIndex].stageName!)")
                            }
                        } else {
                            Text("\(supplier.advertisements[advIndex].companyName!), \(supplier.advertisements[advIndex].companyPosition!)")
                        }
                        Text(user.residentialAddress)
                        Text("\(supplier.advertisements[advIndex].experience) \(supplier.advertisements[advIndex].experienceMeasure) of experience")
                        Text(user.email)
                    }
                    
                }
//                Text(supplier.storyAboutYourself)
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
        }
    }
}

#Preview {
    SupplierCard(supplier: .constant(MWSupplier(id: "BU7G1DeIskbftR05qMc5jL0uIZf2", storyAboutYourself: "Music isn't just my job; it's my lifeblood. From the moment the music starts playing, I feel alive, and I want nothing more than to share that feeling with everyone around me. My sets are more than just a collection of songs; they're stories waiting to be told, emotions waiting to be felt. When I see the crowd moving and feeling the music as deeply as I do, it's like pure magic. That's what being a DJ means to me - spreading joy, energy, and love through the power of music.", advertisements: [SupplierAdvertisemnt(legalStatus: "individual", skill: "DJ", experience: 3, experienceMeasure: "years", storyAboutWork: "I'm Anna, a DJ bursting with passion and energy. When I step behind the decks, it's like stepping into a world where music becomes magic. With every beat I drop, I aim to take my audience on a thrilling journey filled with rhythm and emotion.")])), user: .constant(MWUser(id: "BU7G1DeIskbftR05qMc5jL0uIZf2", email: "anna@gmail.com", name: "Anne", surname: "Daniel", birthday: "31.12.1998", residentialAddress: "Cotati, United States", role: "supplier")), advIndex: .constant(0))
}
