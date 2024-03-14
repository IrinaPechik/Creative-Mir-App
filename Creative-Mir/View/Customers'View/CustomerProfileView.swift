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
//    @State var customer: MWCustomer? = nil
    
    var body: some View {
        VStack {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 200)
                    .padding(.top, 30)
                if let user = user {
                    Text("\(user.name) \(user.surname)")
                        .font(.custom("PlayfairDisplay-Medium", size: 40))
                    Text(user.birthday)
                        .font(.custom("Lora-Regular", size: 20))
                    Text(user.residentialAddress)
                        .font(.custom("Lora-Regular", size: 20))

                    Spacer()
                }
                
            } else {
                ProgressView()
                    .scaleEffect(1.5)
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

#Preview {
    CustomerProfileView(uiImage: UIImage(named: "avatar"), user: MWUser(id: "8M9CPw1LXWON1o2iQ2cb7M0a4OB2", email: "irinapechik@gmail.com", name: "Irina", surname: "Pechik", birthday: "06.10.2003", residentialAddress: "Moscow, Russia", role: "customer"))
}
