//
//  letsAddYourFirstAdvertismentView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 27.02.2024.
//

import SwiftUI

struct letsAddYourFirstAdvertismentView: View {
    @State private var presentNextView = false
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Let's add your first")
                    .font(.custom("Lora-Regular", size: 32))
                Text("advertisement")
                    .font(.custom("PlayfairDisplay-Medium", size: 48))
                Spacer()
                NextButtonViewSecond(buttonText: "Let's go!", isDisabled: false) {
                    presentNextView.toggle()
                }
                .padding(.bottom, 100)
            }
            .navigationDestination(isPresented: $presentNextView) {
                LegalUserInfoView()
            }
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                PageCounter(currentCounter: 2, allPagesCount: 7)
            }
        }
    }
}

#Preview {
    letsAddYourFirstAdvertismentView()
}
