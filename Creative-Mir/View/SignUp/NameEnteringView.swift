//
//  NameEnteringView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 30.01.2024.
//

import SwiftUI

struct NameEnteringView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var presentNextView = false
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 40) {
                Text("Enter your name")
                    .font(.custom("Lora-Regular", size: 32))
                    .padding()
                VStack {
                    customTextView(name: $name, placeholderName: "Name")
                    customTextView(name: $surname, placeholderName: "Surname")
                        .padding(.top)
                }
                .padding()
                NextButtonViewSecond(isDisabled: name.isEmpty || surname.isEmpty) {
                    // Переход к следующей view
                    presentNextView.toggle()
                }
                .padding(.top, 100)
            }
            .navigationDestination(isPresented: $presentNextView) {
                BirthdateEnteringView()
            }
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                PageCounter(currentCounter: 2)
            }
        }
    }
}

#Preview {
    NameEnteringView()
}
