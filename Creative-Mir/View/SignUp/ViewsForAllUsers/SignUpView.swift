//
//  SignUpView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 12.01.2024.
//

import SwiftUI

struct SignUpView: View {
    enum ViewStack: Hashable {
        case login
        case roleChoosing
    }
    @State private var email = ""
    @State private var password = ""
    @State private var repeatedPassword = ""
    
    @State private var isEmailValid = true
    @State private var isFirstPasswordValid = true
    @State private var isRepeatedPasswordValid = true
    
    @FocusState private var focusedField: FocusedField?
    
    @State private var presentNextView = false
    @State private var nextView: ViewStack = .login
    
    @State private var showErrorAlert = false
    @State private var error = ""
    
    @State private var isLoading = false

    
    private var isNextButtonDisabled: Bool {
        !Validator.isEmailCorrect(email) ||    !Validator.isPasswordCorrect(password: password) || (password != repeatedPassword)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("SIGN UP")
                    .font(.custom("PlayfairDisplay-Medium", size: 60))
                
                Text("For Creative-Mir")
                    .font(.custom("FuturaPT-Light", size: 25))
                    .foregroundStyle(Color(red: 106/255, green: 106/255, blue: 106/255))
                    .padding(.bottom, 30)
                
                /// Email text field with validation.
                EmailTextField(email: $email, isEmailValid: $isEmailValid)
                
                /// First password secure field with validation.
                PasswordTextField(password: $password, isFirstPasswordValid: $isFirstPasswordValid)
                    .firstPasswordTFCustomStyle(password: $password, repeatedPassword: $repeatedPassword, isFirstPasswordValid: $isFirstPasswordValid, isRepeatedPasswordValid: $isRepeatedPasswordValid)

                /// Repeated  password secure field with validation.
                SecureTextField(title: "Repeat password", text: $repeatedPassword)
                    .registrationTFCustomStyle()
                    .background(
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .stroke(!isRepeatedPasswordValid ? .red : focusedField == .repeatedPassword ? Color.black : Color(red: 233/255, green: 233/255, blue: 233/255), lineWidth: 1)
                    )
                    .focused($focusedField, equals: .repeatedPassword)
                    .onChange(of: repeatedPassword) {
                        isRepeatedPasswordValid =  Validator.isPasswordCorrect(password: repeatedPassword) && (password == repeatedPassword)
                        // Хитрый ход
                        isFirstPasswordValid = Validator.isPasswordCorrect(password: password) && (password == repeatedPassword)
                    }
                    .padding(.bottom, isRepeatedPasswordValid ? 47 : 0)
                
                if !isRepeatedPasswordValid {
                    HStack {
                        Spacer()
                        Text((password != repeatedPassword) ? "The passwords don't match" : "")
                            .font(.custom("OpenSans-Light", size: 16))
                            .foregroundStyle(.red)
                            .padding(.trailing)
                    }
                    .frame(width: 352)
                    .padding(.bottom, 10)
                }

                VStack(spacing: 20) {
                    NextButtonView(isDisabled: isNextButtonDisabled || isLoading) {
                        email = email.lowercased()
                        nextView = .roleChoosing
                         isLoading = true
                        DatabaseService.shared.checkUserExist(email: email) { exist in
                            if !exist {
                                AuthService.shared.saveUserEmail(email: email)
                                AuthService.shared.savePasswordToKeychain(password: password)
                                nextView = .roleChoosing
                                presentNextView.toggle()
                                isLoading = false
                            } else {
                                showErrorAlert.toggle()
                                self.error = "The email address is already in use by another account."
                                isLoading = false
                            }
                        }
                    }
                    
                    HStack {
                        Text("Already have an account?")
                            .font(.custom("FuturaPT-Light", size: 20))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundStyle(Color(red: 79/255, green: 79/255, blue: 79/255))
                        
                        Button {
                            nextView = .login
                            presentNextView.toggle()
                        } label: {
                            Text("Sign in")
                                .font(.custom("FuturaPT-Light", size: 20))
                                .bold()
                                .underline() // Добавляем подчеркивание
                        }
                        .foregroundStyle(.black)
                    }
                    .frame(width: 352)
                }
            }
            .navigationDestination(isPresented: $presentNextView) {
                switch nextView {
                case .login:
                    SignInView()
                case .roleChoosing:
                    RoleChoosingView()
                }
            }
            .alert(isPresented: $showErrorAlert, content: {
                return Alert(title: Text(self.error), dismissButton: .default(Text("Ok")))
            })
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

#Preview {
    SignUpView()
}

struct RegistrationTFViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 352, height: 63)
            .font(.custom("OpenSans-Light", size: 18))
            .foregroundStyle(.black)
    }
}

private struct FirstPasswordTFViewModifier: ViewModifier {
    @Binding var password: String
    @Binding var repeatedPassword: String
    @Binding var isFirstPasswordValid: Bool
    @Binding var isRepeatedPasswordValid: Bool
    func body(content: Content) -> some View {
        content
            .padding(.bottom, isFirstPasswordValid ? 47 : 0)
            .onChange(of: password) {
                if repeatedPassword.isEmpty {
                    isFirstPasswordValid = Validator.isPasswordCorrect(password: password)
                    // Хитрый ход
                    isRepeatedPasswordValid = true
                } else {
                    if password == repeatedPassword {
                        isFirstPasswordValid = Validator.isPasswordCorrect(password: password)
                    } else {
                        isFirstPasswordValid = false
                    }
                    // Хитрый ход
                    isRepeatedPasswordValid = Validator.isPasswordCorrect(password: repeatedPassword)
                }
            }
            if !isFirstPasswordValid {
                HStack {
                    Spacer()
                    Text(((!repeatedPassword.isEmpty) && (password != repeatedPassword)) ? "The passwords don't match" : "Password must be 6-20 chars with a number, uppercase and lowercase")
                        .font(.custom("OpenSans-Light", size: 16))
                        .foregroundStyle(.red)
                        .padding(.trailing)
                }
                .frame(width: 352)
                .padding(.bottom, 10)
            }
    }
}
 

extension View {
    func registrationTFCustomStyle() -> some View {
        modifier(RegistrationTFViewModifier())
    }
    
    func firstPasswordTFCustomStyle(password: Binding<String>, repeatedPassword: Binding<String>, isFirstPasswordValid: Binding<Bool>, isRepeatedPasswordValid: Binding<Bool>) -> some View {
        modifier(FirstPasswordTFViewModifier(password: password, repeatedPassword: repeatedPassword, isFirstPasswordValid: isFirstPasswordValid, isRepeatedPasswordValid: isRepeatedPasswordValid))
    }
}
