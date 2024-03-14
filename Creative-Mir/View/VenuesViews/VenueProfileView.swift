//
//  VenueProfileView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 14.03.2024.
//

import SwiftUI

struct VenueProfileView: View {
    enum ViewStack {
        case signIn
    }
    @State var uiImages: [UIImage] = []
    @State private var nextView: ViewStack = .signIn
    @State private var presentNextView: Bool = false
    var body: some View {
        VStack {
            Text("VenueProfileView")
            ForEach(uiImages, id: \.self) { uiImage in
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100) // Настройте размер по вашему усмотрению
                        .padding(.vertical, 5)
                }
            Button("Log out") {
                Task {
                    do {
                        try AuthService.shared.signOut()
                        presentNextView.toggle()
                        nextView = .signIn
                    } catch {
                        
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $presentNextView) {
            switch nextView {
            case .signIn:
                SignInView()
            }
        }
        .onAppear {
            print(AuthService.shared.currentUser?.uid  ?? "id")
            StorageService.shared.downloadVenuesPhotoFromWorkImages(id: AuthService.shared.currentUser?.uid ?? "id", completion: {
                result in
                switch result {
                case .success(let data):
                    for d in data {
                        if let img = UIImage(data: d) {
                            uiImages.append(img)
                        }
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
}

#Preview {
    VenueProfileView()
}
