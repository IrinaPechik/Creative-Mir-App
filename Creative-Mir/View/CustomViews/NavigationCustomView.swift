//
//  BackButtonCustomView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 31.01.2024.
//

import SwiftUI

struct customBackButton: View {
    @Environment(\.presentationMode)
    var presentationMode
    var body: some View {
        Button (
            action: {
                self.presentationMode.wrappedValue.dismiss()
            })
        {
            Image(systemName: "chevron.backward")
            .foregroundStyle(.black)
            .font(.system(size: 20))
//            .padding(.top, 20)
        }
    }
}

struct PageCounter: View {
    var currentCounter: Int
    var body: some View {
        Text("\(currentCounter)/10")
            .font(.custom("FuturaPT-Light", size: 30))
            .foregroundStyle(.black)
//            .padding(.top, 20)
    }
}


