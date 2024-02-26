//
//  CustomNextButtonsView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 31.01.2024.
//

import SwiftUI

struct NextButtonViewSecond: View {
    let buttonText: String
    let isDisabled: Bool
    let action: () -> Void
    public var body: some View {
        Button(action: action, label: {
            Text(buttonText)
                .foregroundStyle(Color(red: 255/255, green: 213/255, blue: 151/255))
                .font(.custom("Marcellus-Regular", size: 20))
        })
        .frame(width: 212, height: 65)
        .background(Color(red: 49/255, green: 40/255, blue: 36/255))
        .opacity(isDisabled ? 0.6 : 1)
        
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color(red: 255/255, green: 213/255, blue: 151/255), lineWidth: 2)
        )

        .disabled(isDisabled)
    }
}

public struct NextButtonView: View {
    let isDisabled: Bool
    let action: () -> Void
    
    public var body: some View {
        Button(action: action, label: {
            Text("Next")
                .foregroundStyle(.white)
                .font(.custom("Marcellus-Regular", size: 20))
        })
        .frame(width: 352, height: 65)
        .background(Color.black)
        .opacity(isDisabled ? 0.6 : 1)

        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        .disabled(isDisabled)
    }
}
