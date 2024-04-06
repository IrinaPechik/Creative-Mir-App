//
//  ProfileView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 13.03.2024.
//

import SwiftUI

struct CustomerProfileView: View {
    enum ViewStack {
        case signIn
    }
    @State var uiImage: UIImage? = nil
    @State private var nextView: ViewStack = .signIn
    @State private var presentNextView: Bool = false
    @State var user: MWUser? = nil
    var body: some View {
        VStack() {
            HStack {
                Spacer()
                Button {
                    Task {
                        do {
                            try AuthService.shared.signOut()
                            presentNextView.toggle()
                            nextView = .signIn
                        } catch {
                            
                        }
                    }
                } label: {
                    Text("Log out")
                        .font(customFont: .ManropeBold, size: 20)
                }
                .foregroundStyle(.black)
                .padding(.trailing)

            }
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300)
                    .padding(.top, 30)
                if let user = user {
                    VStack {
                        Text("\(user.name) \(user.surname)")
                            .font(customFont: .PlayfairDisplayMedium, size: 40)
                            .padding()
                        HStack {
                            Text("Birth date:")
                                .font(customFont: .LoraRegular, size: 25)
                                .padding(.trailing)
                            Text(user.birthday)
                                .font(customFont: .OpenSansLight, size: 20)
                            Spacer()
                        }
                        .padding()
                        
                        HStack {
                            Text("Residential address:")
                                .font(customFont: .LoraRegular, size: 25)
                                .padding(.trailing)
                            Text(user.residentialAddress)
                                .font(customFont: .OpenSansLight, size: 20)
                            Spacer()
                        }
                        .padding()
                        
                        HStack {
                            Text("Email:")
                                .font(customFont: .LoraRegular, size: 25)
                                .padding(.trailing)
                            Text(user.email)
                                .font(customFont: .OpenSansLight, size: 20)
                            Spacer()
                        }
                        .padding()
                        Spacer()
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .ignoresSafeArea(edges: .bottom)
                }
                
            } else {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .ignoresSafeArea(edges: .bottom)

        .fullScreenCover(isPresented: $presentNextView) {
            switch nextView {
            case .signIn:
                SignInView()
            }
        }
        .onAppear {
            DatabaseService.shared.getUser(id: AuthService.shared.currentUser!.uid) { result in
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print(error)
                }
            }
            StorageService.shared.downloadUserAvatarImage(id: AuthService.shared.currentUser?.uid ?? "id") {result in
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
