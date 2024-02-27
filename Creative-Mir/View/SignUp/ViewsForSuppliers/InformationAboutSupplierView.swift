//
//  InformationAboutSupplierView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 26.02.2024.
//

import SwiftUI

struct InformationAboutSupplierView: View {
    @State var storyAboutYourself: String = ""
    @State private var presentNextView = false

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Reveal").font(.custom("PlayfairDisplay-Medium", size: 48))
                Text("your personality")
                    .font(.custom("Lora-Regular", size: 32))
                TextField("Tell us about yourself", text: $storyAboutYourself, axis: .vertical)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
                    .lineLimit(9...)
                    .font(.custom("Lora-Regular", size: 18))
                NextButtonViewSecond(buttonText: "R E V E A L", isDisabled: storyAboutYourself.isEmpty) {
                    AuthService.shared.saveSupplierStoryAboutYourself(storyAboutYourself: storyAboutYourself)
                    presentNextView.toggle()
                }
            }
            .navigationDestination(isPresented: $presentNextView) {
                letsAddYourFirstAdvertismentView()
            }
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                PageCounter(currentCounter: 1, allPagesCount: 7)
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    InformationAboutSupplierView()
}
