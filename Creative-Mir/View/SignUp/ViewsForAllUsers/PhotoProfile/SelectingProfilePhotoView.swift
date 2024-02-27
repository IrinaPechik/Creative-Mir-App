//
//  SelectingProfilePhotoView.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 26.02.2024.
//

import SwiftUI

struct SelectingProfilePhotoView: View {
    @EnvironmentObject var vm: PhotoPickerViewModel
    @State private var actionSheetVisible = false
    @State private var presentNextView = false

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Select your profile photo")
                    .font(.custom("Lora-Regular", size: 30))
                PhotoPickerView(avatarImage: $vm.image)
                    .onTapGesture {
                        actionSheetVisible = true
                    }
                    .padding(90)
                NextButtonViewSecond(buttonText: "F I N I S H", isDisabled: vm.image == nil) {
                    // Переход к следующей view
                    presentNextView.toggle()
                }
                .padding(.bottom, 20)
            }
            .confirmationDialog("Choose photo", isPresented: self.$actionSheetVisible) {
                Button("Photo library") {
                    vm.source = .library
                    vm.showPicker = true
                }
                Button("Camera") {
                    vm.source = .camera
                    vm.showPhotoPicker()
                }
                Button("Delete photo", role: .destructive) {
                    vm.showPicker = false
                    vm.image = nil
                }
            }
            .sheet(isPresented: $vm.showPicker, content: {
                ImagePicker(sourceType: vm.source == .library ? .photoLibrary : .camera, selectedImage: $vm.image)
                    .ignoresSafeArea()
            })
            .alert("Error", isPresented: $vm.showCameraAlert, presenting: vm.cameraError) { cameraError in
                cameraError.button
            } message: { cameraError in
                Text(cameraError.message)
            }
            .navigationDestination(isPresented: $presentNextView) {
                switch AuthService.shared.getUserRole() {
                case String(describing: UserRoles.customer):
                    Text("customer")
                case String(describing: UserRoles.supplier):
                    InformationAboutSupplierView()
//                    Text("supplier")
                case String(describing: UserRoles.venue):
                    Text("venue")
                default:
                    // Ошибочка, перенаправить на главную страницу
                    Text("user")
                }
            }
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                PageCounter(currentCounter: 5)
            }
        }
    }
}

#Preview {
    SelectingProfilePhotoView()
        .environmentObject(PhotoPickerViewModel())
}
