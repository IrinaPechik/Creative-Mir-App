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
        VStack(alignment: .center) {
            Text("Reveal").font(.custom("PlayfairDisplay-Medium", size: 48))
            Text("your personality")
                .font(.custom("Lora-Regular", size: 32))
            TextField("Tell us about yourself", text: $storyAboutYourself, axis: .vertical)
                .multilineTextAlignment(.leading)
                .padding()
                .background(.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding()
                .lineLimit(9...)
                .font(.custom("Lora-Regular", size: 18))
            NextButtonViewSecond(buttonText: "R E V E A L", isDisabled: storyAboutYourself.isEmpty || storyAboutYourself == "Tell us about yourself") {
                presentNextView.toggle()
            }
        }
        
    }
}

#Preview {
    InformationAboutSupplierView()
}
