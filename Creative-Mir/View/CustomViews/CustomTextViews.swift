//
//  CustomTextViews.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 31.01.2024.
//

import SwiftUI

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
        }
        .frame(width: 320) // Ширина текстового поля
        .padding()
    }
}

struct customTextView2: View {
    @Binding var name: String
    var placeholderName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(placeholderName).font(.custom("Marcellus-Regular", size: 15))
            TextField("", text: $name)
                .font(.custom("Lora-Regular", size: 18))
                .frame(height: 25) // Высота текстового поля
                .overlay(
                    Rectangle().frame(height: 1),
                    alignment: .bottomLeading) // Нижняя линия
                .foregroundColor(.black) // Цвет текста
        }
        .frame(width: 320) // Ширина текстового поля
        .padding()
    }
}

struct customTextView3: View {
    @Binding var name: String?
    var placeholderName: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(placeholderName).font(.custom("Marcellus-Regular", size: 15))
            TextField("", text: Binding(
                get: { self.name ?? "" },
                set: { self.name = $0 }
            ))
                .font(.custom("Lora-Regular", size: 18))
                .frame(height: 25) // Высота текстового поля
                .overlay(
                    Rectangle().frame(height: 1),
                    alignment: .bottomLeading) // Нижняя линия
                .foregroundColor(.black) // Цвет текста
        }
        .frame(width: 320) // Ширина текстового поля
        .padding()
    }
}
