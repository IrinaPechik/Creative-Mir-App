//
//  UpploadPhotoFromWork + Extension.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 02.03.2024.
//

import SwiftUI

extension UpploadPhotoFromWork {
    var imageScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(vm.myImages) { myImage in
                    VStack {
                        Image(uiImage: myImage.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                    }
                    .onTapGesture {
                        vm.display(myImage)
                    }
                }
            }
        }.padding(.horizontal)
    }
    
    // Отображение дефолтной фотографии или выбранной.
    var selectedImage: some View {
        Group {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .photoPickerCustomStyle(width: 180, height: 180)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ZStack {
                    // Добавляем circle снизу, чтобы весь кружок был кликабельным, а не только стрлочка и обводка.
                    Circle().foregroundStyle(.white).frame(width: 220)
                    Image(systemName: "arrow.down.to.line")
                        .scaleEffect(1.7)
                        .foregroundStyle(.black)
                        .photoPickerCustomStyle(width: 180, height: 180)
                        .overlay(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                .foregroundColor(.black)
                        )
                }
                .onTapGesture {
                    actionSheetVisible = true
                }
            }
        }
    }
    // Редактирование фото (на самом деле - удаление просто)
    var editGroup: some View {
        Group {
            HStack {
                Button {
                    if vm.selectedImage == nil {
                        vm.addMyImage("", image: vm.image!)
                    } else {
                        vm.updateSelected()
                    }
                } label: {
                    if vm.selectedImage == nil {
                        ButtonLabel(symbolName: "square.and.arrow.down.fill",
                                    label: "Save")
                    }
                }
                .disabled(vm.buttonDisabled)
                .opacity(vm.buttonDisabled ? 0.6 : 1)
                if !vm.deleteButtonIsHidden {
                    Button {
                        vm.deleteSelected()
                    } label: {
                        ButtonLabel(symbolName: "trash", label: "Delete")
                    }
                }
            }
        }
    }
}
