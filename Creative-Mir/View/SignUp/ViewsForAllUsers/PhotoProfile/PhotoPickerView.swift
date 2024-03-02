//
//  SelectingProfilePhotoView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 26.02.2024.
//

import SwiftUI

struct PhotoPickerView: View {
    @Binding var avatarImage: UIImage?
//    @EnvironmentObject var viewModel: PhotoPickerViewModel
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        if let avatarImage = avatarImage {
            Image(uiImage: avatarImage)
                .resizable()
                .scaledToFill()
                .photoPickerCustomStyle(width: width, height: height)
                .foregroundColor(.red)
        } else {
            ZStack {
                // Добавляем circle снизу, чтобы весь кружок был кликабельным, а не только стрлочка и обводка.
                Circle().foregroundStyle(.white)
                Image(systemName: "arrow.down.to.line")
                    .scaleEffect(1.7)
                    .foregroundStyle(.black)
                    .photoPickerCustomStyle(width: width, height: height)
                    .overlay(
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .foregroundColor(.black)
                    )
            }
        }
    }
}

struct photoPickerViewModifier: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}

extension View {
    func photoPickerCustomStyle(width: CGFloat, height: CGFloat) -> some View {
        modifier(photoPickerViewModifier(width: width, height: height))
    }
}


//#Preview {
//    SelectingProfilePhotoView()
//}
