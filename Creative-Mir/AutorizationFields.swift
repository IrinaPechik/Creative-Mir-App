//
//  PasswordField.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 17.01.2024.
//

import Foundation
import SwiftUI

enum FocusedField {
    case email
    case password
    case repeatedPassword
}

struct SecureTextField: View {
    @State private var isSecureField: Bool = true
    var title: String
    @Binding var text: String
        
    var body: some View {
        HStack {
            if isSecureField {
                SecureField(title, text: $text)
            } else {
                TextField(text, text: $text)
            }
        }.overlay(alignment: .trailing) {
            Image(systemName: isSecureField ? "eye.slash": "eye")
                .onTapGesture {
                    isSecureField.toggle()
                }
        }
    }
}

struct PasswordTextField: View {
    @Binding var password: String
    @Binding var isFirstPasswordValid: Bool
    
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        /// First password secure field with validation.
        SecureTextField(title: "Enter password", text: $password)
            .registrationTFCustomStyle()
            .background(
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .stroke(!isFirstPasswordValid ? .red : focusedField == .password ? Color.black : Color(red: 233/255, green: 233/255, blue: 233/255), lineWidth: 1)
            )
            .focused($focusedField, equals: .password)
    }
}

struct EmailTextField: View {
    @Binding var email: String
    @Binding var isEmailValid: Bool
    
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            /// Email text field with validation.
            TextField("Enter your email", text: $email)
                .registrationTFCustomStyle()
                .background(
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .stroke(!isEmailValid ? .red :   focusedField == .email ? Color.black : Color(red: 233/255, green: 233/255, blue: 233/255), lineWidth: 1)
                )
                .focused($focusedField, equals: .email)
                .onChange(of: email) {
                    isEmailValid =  Validator.isEmailCorrect(email)
                }
                .padding(.bottom, isEmailValid ? 47 : 0)
                .keyboardType(.emailAddress)
            
            if !isEmailValid {
                HStack {
                    Spacer()
                    Text("Your email is not valid")
                        .font(.custom("OpenSans-Light", size: 18))
                        .foregroundStyle(.red)
                        .padding(.trailing)
                }
                .frame(width: 352)
                .padding(.bottom, 10)
            }
        }
    }
}
