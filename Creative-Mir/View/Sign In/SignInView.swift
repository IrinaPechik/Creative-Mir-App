//
//  SignInView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 17.01.2024.
//

import SwiftUI
struct SignInView: View {
    enum ViewStack {
        case signUp
        case signIn
        case forgotPassword
    }
    @State private var email = ""
    @State private var password = ""
    @State private var userRole: String = ""
    
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    
    @FocusState private var focusedField: FocusedField?
    
    @State private var presentNextView = false
    @State private var nextView: ViewStack = .signUp
    @State private var showErrorAlert = false
    
    private var isSignInButtonDisabled: Bool {
        !Validator.isEmailCorrect(email) || password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("SIGN IN")
                    .font(.custom("PlayfairDisplay-Medium", size: 60))
                
                Text("To Creative-Mir")
                    .font(.custom("FuturaPT-Light", size: 25))
                    .foregroundStyle(Color(red: 106/255, green: 106/255, blue: 106/255))
                    .padding(.bottom, 30)
                
                /// Email text field with validation.
                EmailTextField(email: $email, isEmailValid: $isEmailValid)
                
                /// First password secure field with validation.
                PasswordTextField(password: $password, isFirstPasswordValid: $isPasswordValid)
                
                Button {
                    nextView = .forgotPassword
                    presentNextView.toggle()
                } label: {
                    Text("Forget password")
                        .foregroundStyle(.black)
                }
                .padding(.top, 4)
                .frame(width: 352, alignment: .trailing)
                .font(.custom("FuturaPT-Light", size: 20))
                

                // Тут еще чекнуть
                VStack(spacing: 20) {
                    SignInButtonView(isDisabled: isSignInButtonDisabled) {
                        AuthService.shared.signIn(email: email, password: password) { result in
                            switch result {
                            case .success(_):
                                nextView = .signIn
                                DatabaseService.shared.getUserRole(email: email.lowercased()) { res in
                                    switch res {
                                    case .success(var role):
                                        userRole = role
                                        AuthService.shared.saveUserRole(role: userRole)
                                        AuthService.shared.saveUserId(id: AuthService.shared.currentUser?.uid ?? "id")
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                                presentNextView.toggle()
                            case .failure(_):
                                print("error")
                                showErrorAlert.toggle()
                            }
                        }
                    }
                    HStack {
                        Text("Don't have an account?")
                            .font(.custom("FuturaPT-Light", size: 20))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundStyle(Color(red: 79/255, green: 79/255, blue: 79/255))
                        Button {
                            nextView = .signUp
                            presentNextView.toggle()
                        } label: {
                            Text("Sign up")
                                .font(.custom("FuturaPT-Light", size: 20))
                                .bold()
                                .underline() // Добавляем подчеркивание
                        }
                        .foregroundStyle(.black)
                    }
                    .frame(width: 352)
                }
                .padding(.top, 15)
            }
            .navigationDestination(isPresented: $presentNextView) {
                switch nextView {
                case .signUp:
                    SignUpView()
                case .signIn:
//                    let userRole = AuthService.shared.getUserRole()
                    if userRole == "customer" {
                        RootView()
                    } else if userRole == "supplier" {
                       SupplierProfileView()
                    } else if userRole == "venue" {
                        VenueProfileView()
                    } 
                    
                case .forgotPassword:
                    ForgotPasswordView()
                }
            }
            .alert(isPresented: $showErrorAlert) {
                return Alert(title: Text("Invalid email or password"), dismissButton: .default(Text("Ok")))
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
        }
    }
}

private struct SignInButtonView: View {
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text("SIGN IN")
                .foregroundStyle(.white)
                .font(.custom("OpenSans-Regular", size: 20))
        })
        .frame(width: 352, height: 65)
        .background(Color.black)
        .opacity(isDisabled ? 0.6 : 1)

        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        .disabled(isDisabled)
    }
}

#Preview {
    SignInView()
}

