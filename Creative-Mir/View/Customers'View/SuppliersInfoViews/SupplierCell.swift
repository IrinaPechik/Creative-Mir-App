//
//  SupplierCard.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 14.03.2024.
//

import SwiftUI

struct SupplierCell: View {
    @StateObject var viewModel: ExploreSuplierViewModel

    @State var supplier: MWSupplier
    @State var advIndex: Int
    @State var uiImage: UIImage? = nil
    @State var isLiked = false

    @State var user: MWUser? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            if let user = user {
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
                            Image(systemName: "heart")
                                .font(.title2)
                                .foregroundColor(isLiked ? .black : Color(red: 191/255, green: 194/255, blue: 200/255))
                                .padding(10)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isLiked.toggle()
                                    }
                                    if isLiked {
                                        viewModel.addLikeToSupplier(customerId: AuthService.shared.currentUser?.uid ?? "id", supplier: self.supplier)
                                    } else {
                                        viewModel.removeLikeFromSupplier(customerId: AuthService.shared.currentUser?.uid ?? "id", supplier: self.supplier)
                                    }
                                }
                        }
                    }
            }
        }
        .frame(width: 380, height: 100)
        .background()

        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 3, y: 3)
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
            DatabaseService.shared.getUser(id: supplier.id) { result in
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            DatabaseService.shared.checkWasSupplierLikedById(customerId: AuthService.shared.currentUser?.uid ?? "id", supplierId: supplier.id) { res in
                switch res {
                case .success(let wasLiked):
                    isLiked = wasLiked
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    SupplierCell(viewModel: ExploreSuplierViewModel(), supplier: MWSupplier(id: "1", storyAboutYourself: "i am the best", advertisements: [SupplierAdvertisemnt(legalStatus: "individual", skill: "DJ", experience: 2, experienceMeasure: "years", storyAboutWork: "ff")]), advIndex: 0, uiImage: UIImage(named: "avatar"), user: MWUser(id: "1", email: "email", name: "ira", surname: "pechik", birthday: "08/10/2003", residentialAddress: "Moscow", role: "supplier"))
//        .shadow(color: Color(uiColor: UIColor(red: 0/255, green: 12/255, blue: 75/255, alpha: 0.06)),radius: 8, x: 3, y: 3)
}
