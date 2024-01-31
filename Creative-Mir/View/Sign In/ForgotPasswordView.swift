//
//  ForgotPasswordView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 19.01.2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var showAlert = false
    @State private var errString: String?
    
    @State private var email = ""
    @State private var isEmailValid = true
    
    private var isResetPasswordButtonDisabled: Bool {
        !Validator.isEmailCorrect(email)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Enter your email adress")
                    .font(.custom("PlayfairDisplay-Medium", size: 30))
                Text("you used to register")
                    .font(.custom("FuturaPT-Light", size: 25))
                    .foregroundStyle(Color(red: 106/255, green: 106/255, blue: 106/255))
                    .padding(.bottom, 30)
                /// Email text field with validation.
                EmailTextField(email: $email, isEmailValid: $isEmailValid)
                Button {
                    AuthService.shared.resetPassword(email: email) { result in
                        switch result {
                        case .failure(let error):
                            self.errString = error.localizedDescription
                        case .success(_):
                            break
                        }
                        self.showAlert = true
                    }
                } label: {
                    Text("Reset password")
                        .foregroundStyle(.white)
                        .font(.custom("OpenSans-Regular", size: 20))
                }
                .frame(width: 352, height: 65)
                .background(Color.black)
                .opacity(isResetPasswordButtonDisabled ? 0.6 : 1)

                .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                .disabled(isResetPasswordButtonDisabled)
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Password Reset"),
                      message: Text(self.errString ?? "Success. Reset email sent successfully. Check your email"), dismissButton: .default(Text("Ok")))
            })
        }
    }
}

#Preview {
    ForgotPasswordView()
}
