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
    var body: some View {
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
            NextButtonView(isDisabled: name.isEmpty || surname.isEmpty) {
                // Переход к следующей view
            }
            .padding()
        }
    }
}

#Preview {
    NameEnteringView()
}

struct customTextView: View {
    @Binding var name: String
    var placeholderName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(placeholderName).font(.custom("Marcellus-Regular", size: 15))
            TextField("", text: $name)
                .font(.custom("Lora-Regular", size: 18))
                .frame(height: 35) // Высота текстового поля
                .overlay(
                    Rectangle().frame(height: 1),
                    alignment: .bottomLeading) // Нижняя линия
                .foregroundColor(.black) // Цвет текста
            
//            Spacer()
        }
        .frame(width: 320) // Ширина текстового поля
        .padding()
    }
}

public struct NextButtonViewNew: View {
    let isDisabled: Bool
    let action: () -> Void
    
    public var body: some View {
        Button(action: action, label: {
            Text("N E X T")
                .foregroundStyle(Color(red: 255/255, green: 213/255, blue: 151/255))
                .font(.custom("Marcellus-Regular", size: 20))
        })
        .frame(width: 185, height: 65)
        .background(Color.black)
        .opacity(isDisabled ? 0.6 : 1)
        
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color(red: 255/255, green: 213/255, blue: 151/255), lineWidth: 2)
        )

        .disabled(isDisabled)
    }
}


