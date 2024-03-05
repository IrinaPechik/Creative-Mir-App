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
    private var auth = AuthService.shared
    @State private var isLoading = false


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
                NextButtonViewSecond(buttonText: "F I N I S H", isDisabled: vm.image == nil || isLoading) {
                    isLoading = true
                    // Переход к следующей view
                    let jpegImage = vm.image?.jpegData(compressionQuality: 0.8)
                    
                    AuthService.shared.saveUserProfilePhoto(profilePhotoJpeg: jpegImage)

                    // Если customer - то тут регистрируем и далее переходим в личный кабинет.
                    // Если performer - регистрируем там, где заканчивается ввод их данных.
                    let userRole = AuthService.shared.getUserRole()
                    if userRole == String(describing: UserRoles.customer) {
                        auth.signUp(email: auth.getUserEmail(), password: auth.getPasswordFromKeyChain()) { result in
                            switch result {
                            case .success(_):
                                DatabaseService.shared.setUser(user: MWUser(id: auth.getUserId(), email: auth.getUserEmail(), name: auth.getUserName(), surname: auth.getUserSurname(), birthday: auth.getUserBirthDateStr(), residentialAddress: auth.getUserLivingAddress(), avatarImage: auth.getUserProfilePhoto(), role: auth.getUserRole())) { result in
                                    switch result {
                                    case .success(_):
                                        let customer = MWCustomer(id: auth.getUserId())
                                        
                                        // Загрузка данных исполнителя в базу данных
                                        DatabaseService.shared.setCustomer(customer: customer) { result in
                                            DispatchQueue.main.async {
                                                switch result {
                                                case .success(_):
                                                    self.presentNextView.toggle()
                                                    self.isLoading = false
                                                case .failure(let error):
                                                    self.showErrorAlert.toggle()
                                                    self.error = error.localizedDescription
                                                    self.isLoading = false
                                                }
                                            }
                                        }
                                    case .failure(let error):
                                        showErrorAlert.toggle()
                                        self.error = error.localizedDescription
                                        isLoading = false
                                    }
                                }
                            case .failure(let error):
                                showErrorAlert.toggle()
                                self.error = error.localizedDescription
                                isLoading = false
                            }
                        }
                    } else {
                        presentNextView.toggle()
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
                    // Переход в личный кабинет
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
