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
    @State private var showErrorAlert = false
    @State private var error = ""


    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Select your profile photo")
                    .font(.custom("Lora-Regular", size: 30))
                PhotoPickerView(avatarImage: $vm.image, width: 228, height: 228)
                    .onTapGesture {
                        actionSheetVisible = true
                    }
                    .padding(90)
                NextButtonViewSecond(buttonText: "F I N I S H", isDisabled: vm.image == nil) {
                    // Переход к следующей view
                    let jpegImage = vm.image?.jpegData(compressionQuality: 0.8)
                    AuthService.shared.saveUserProfilePhoto(profilePhotoJpeg: jpegImage)
                    presentNextView.toggle()
                    
                    DatabaseService.shared.setUser(user: MWUser(id: AuthService.shared.getUserId(), name: AuthService.shared.getUserName(), surname: AuthService.shared.getUserSurname(), birthday: AuthService.shared.getUserBirthDateStr(), residentialAddress: AuthService.shared.getUserLivingAddress(), avatarImage: AuthService.shared.getUserProfilePhoto(), role: AuthService.shared.getUserRole())) { result in
                        switch result {
                        case .success(_):
                            presentNextView.toggle()
                        case .failure(let error):
                            showErrorAlert.toggle()
                            self.error = error.localizedDescription
                        }
                    }
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
                case String(describing: UserRoles.venue):
                    letsAddYourFirstAdvertismentView()
                default:
                    // Ошибочка, перенаправить на главную страницу
                    Text("user")
                }
            }
            .alert(isPresented: $showErrorAlert, content: {
                return Alert(title: Text(self.error), dismissButton: .default(Text("Ok")))
            })
        }
        // Скрываем системную кнопку Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                PageCounter(currentCounter: 5, allPagesCount: 5)
            }
        }
    }
}

#Preview {
    SelectingProfilePhotoView()
        .environmentObject(PhotoPickerViewModel())
}
