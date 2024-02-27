//
//  CompanyOrIndividualPersonView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 27.02.2024.
//

import SwiftUI

struct CompanyOrIndividualPersonView: View {
    @State private var selectedStatus: Int = 1
    @State private var presentNextView = false

    let roleOptions = [ComapanyOrIndividalPerformer.individual, ComapanyOrIndividalPerformer.company]

    var body: some View {
        NavigationView {
            VStack {
                Text("You are")
                    .font(.custom("Lora-Regular", size: 48))
                    .padding(.bottom, 180)
                Picker("Who are you?", selection: $selectedStatus) {
                    ForEach(0 ..< roleOptions.count) {
                        Text(roleOptions[$0].rawValue)
                            .font(.custom("Lora-Regular", size: 18))
                    }
                }
                .padding(.top, -150)
                .scaleEffect(1.5)
                .pickerStyle(.wheel)
                NextButtonViewSecond(buttonText: "N E X T", isDisabled: false) {
                    AuthService.shared.savePerformerCompanyOrIndividualStatus(companyOrIndividualStatus: String(describing: roleOptions[selectedStatus]))
                    print(AuthService.shared.getPerformerCompanyOrIndividualStatus())
                    presentNextView.toggle()
                }
            }.navigationDestination(isPresented: $presentNextView) {
                Text("Next")
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
    CompanyOrIndividualPersonView()
}
