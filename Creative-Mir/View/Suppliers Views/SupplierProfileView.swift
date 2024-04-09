//
//  SupplierProfileView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 14.03.2024.
//

import SwiftUI

struct SupplierProfileView: View {
    enum ViewStack {
        case signIn
    }
//    @State var uiImages: [UIImage] = []
    @State private var nextView: ViewStack = .signIn
    @State private var presentNextView: Bool = false
    @State var user: MWUser = MWUser(id: "id", email: "email", name: "name", surname: "surname", birthday: "birthday", residentialAddress: "residentialAddress", role: "residentialAddress")
    @State var supplier: MWSupplier = MWSupplier(id: "id")
    @State private var isLoading = true
    @State var isEditing: Bool = false

    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                VStack {
                    HStack {
                        Spacer()
                        Button("Log out") {
                            Task {
                                do {
                                    try AuthService.shared.signOut()
                                    
                                    if let bundleIdentifier = Bundle.main.bundleIdentifier {
                                        UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
                                    }
                        
                        
                                    let defaults = UserDefaults.standard
                                    let dictionary = defaults.dictionaryRepresentation()
                        
                                    dictionary.keys.forEach { key in
                                        defaults.removeObject(forKey: key)
                                    }
                                    
                                    presentNextView.toggle()
                                    nextView = .signIn
                                } catch {
                                    
                                }
                            }
                        }
                        .foregroundStyle(.black)
                        .padding(.trailing)
                    }
                    .background(Color.backgroundColor)
                    HStack {
                        Spacer()
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 24))
                            .foregroundStyle(isEditing ? .black : .gray)
                            .padding(.trailing)
                            .onTapGesture {
                                isEditing.toggle()
                            }
                    }
                    .background(Color.backgroundColor)
                }
                SupplierCard(supplier: $supplier, user: $user, advIndex: .constant(0))
            }
        }
        .fullScreenCover(isPresented: $presentNextView) {
            switch nextView {
            case .signIn:
                SignInView()
            }
        }
        .sheet(isPresented: $isEditing) {
            SupplierProfileEditing(viewModel: SupplierProfileViewModel(), user: $user, supplier: $supplier, isEditing: $isEditing)
        }
        .onAppear {
            print(AuthService.shared.currentUser?.uid  ?? "id")
            
            DatabaseService.shared.getUser(id: AuthService.shared.currentUser!.uid) { result in
                switch result {
                case .success(let user):
                    self.user = user
                    DatabaseService.shared.getSupplier(id: AuthService.shared.currentUser!.uid) { result in
                        switch result {
                        case .success(let supplier):
                            self.supplier = supplier
                            isLoading = false
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
#Preview {
    SupplierProfileView()
}
