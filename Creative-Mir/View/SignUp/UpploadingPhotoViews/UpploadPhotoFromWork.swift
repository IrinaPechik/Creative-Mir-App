//
//  UpploadPhotoFromWork.swift
//  Creative-Mir
//
//  Created by Печик Ирина on 01.03.2024.
//

import SwiftUI
import PhotosUI

struct UpploadPhotoFromWork: View {
    @State private var presentNextView = false
    
    @State var actionSheetVisible = false
    @EnvironmentObject var vm: PhotoPickerViewModel
    @State private var showErrorAlert = false
    @State private var error = ""
    @State private var isLoading = false
    @State private var userRole: String = ""

    private var auth = AuthService.shared
    var text1: String {
        switch AuthService.shared.getUserRole() {
        case String(describing: UserRoles.supplier):
            return "Upload your"
        case String(describing: UserRoles.venue):
            return "Upload photos"
        default:
            return ""
        }
    }
    
    var text2: String {
        switch AuthService.shared.getUserRole() {
        case String(describing: UserRoles.supplier):
            return "photo from work"
        case String(describing: UserRoles.venue):
            return "of the place"
        default:
            return ""
        }
    }
    
    func handleUserRoleAndNavigate(_ imagesArray: [Data]) {
        userRole = AuthService.shared.getUserRole()
        
        if userRole == String(describing: UserRoles.supplier) {
            let advertisement = SupplierAdvertisemnt(legalStatus: auth.getPerformerCompanyOrIndividualStatus(), stageName: auth.getSupplierStageName(), companyName: auth.getPerformerCompanyName(), companyPosition: auth.getPerformerPositionInCompany(), skill: auth.getSupplierFirstSkill(), experience: auth.getSupplierFirstSkillExperience(), experienceMeasure: auth.getSupplierFirstSkillExperienceMeasure(), storyAboutWork: auth.getSupplierStoryAboutWork())
            
            var supplier = MWSupplier(id: auth.getUserId(), storyAboutYourself: auth.getSupplierStoryAboutYourself())
            supplier.addAdvertisement(advertisement: advertisement)
            
            // Загрузка данных исполнителя в базу данных
            DatabaseService.shared.setSupplier(supplier: supplier, images: imagesArray) { result in
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
        } else if userRole == String(describing: UserRoles.venue) {
            let advertisement = VenueAdvertisemnt(legalStatus: auth.getPerformerCompanyOrIndividualStatus(), companyName: auth.getPerformerCompanyName(), companyPosition: auth.getPerformerPositionInCompany(), locationAddress: auth.getVenueBuildingAddress(), locationName: auth.getVenueBuildingName(), locationDescription: auth.getVenuePlaceDescription(), photosFromWork: imagesArray)
            
            var venue = MWVenue(id: auth.getUserId())
            venue.addAdvertisement(advertisement: advertisement)
            
            // Загрузка данных исполнителя в базу данных
            DatabaseService.shared.setVenue(venue: venue, images: imagesArray) { result in
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
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    Text(text1)
                        .font(.custom("Lora-Regular", size: 35))
                        .padding(.top, 60)
                    Text(text2)
                        .font(.custom("Lora-Regular", size: 35))
                        .padding(.bottom, 30)
                    
                    VStack {
                        selectedImage.padding(vm.myImages.isEmpty ? 60 : 0)
                        
                        if !vm.isEditing {
                            imageScroll
                        }
                        VStack {
                            if vm.image != nil {
                                editGroup
                            }
                        }
                        .padding()
                        Spacer()
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
                    }
                    .task {
                        if FileManager().docExist(named: fileName) {
                            vm.loadMyImagesJSONFile()
                        }
                    }
                    .sheet(isPresented: $vm.showPicker) {
                        ImagePicker(sourceType: vm.source == .library ? .photoLibrary : .camera, selectedImage: $vm.image)
                            .ignoresSafeArea()
                    }
                    .alert("Error", isPresented: $vm.showFileAlert, presenting: vm.appError, actions: { cameraError in
                        cameraError.button
                    }, message: { cameraError in
                        Text(cameraError.message)
                    })
                    
                    
                    NextButtonViewSecond(buttonText: "N E X T", isDisabled: vm.myImages.isEmpty || isLoading) {
                        isLoading = true
                        var imagesArray: [Data] = []
                        
                        // Сжатие изображений в фоновом потоке
                        for currentImage in vm.myImages {
                            if let jpegImage = currentImage.image.jpegData(compressionQuality: 0.2) {
                                imagesArray.append(jpegImage)
                            }
                        }
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            auth.signUp(email: auth.getUserEmail(), password: auth.getPasswordFromKeyChain()) { result in
                                switch result {
                                case .success(_):
                                    let user = MWUser(id: auth.getUserId(), email: auth.getUserEmail(), name: auth.getUserName(), surname: auth.getUserSurname(), birthday: auth.getUserBirthDateStr(), residentialAddress: auth.getUserLivingAddress(), role: auth.getUserRole())
                                    // Запись пользователя в базу данных также в фоновом потоке
                                    DatabaseService.shared.setUser(user: user, imageData: auth.getUserProfilePhoto()!) { result in
                                        DispatchQueue.main.async {
                                            switch result {
                                            case .success(_):
                                                self.handleUserRoleAndNavigate(imagesArray)
                                            case .failure(let error):
                                                self.showErrorAlert.toggle()
                                                self.error = error.localizedDescription
                                                self.isLoading = false
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    DispatchQueue.main.async {
                                        self.showErrorAlert.toggle()
                                        self.error = error.localizedDescription
                                        self.isLoading = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $presentNextView) {
                // TODO: в зависимости от того, какой пользователь, показывать страницу
                if userRole == String(describing: UserRoles.supplier) {
                    SupplierProfileView()
                } else if userRole == String(describing: UserRoles.venue) {
                    VenueProfileView()
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
                PageCounter(currentCounter: 5, allPagesCount: 7)
            }
        }
    }
}

#Preview {
    UpploadPhotoFromWork()
        .environmentObject(PhotoPickerViewModel())
}

struct ButtonLabel: View {
    let symbolName: String
    let label: String
    var body: some View {
        HStack {
            Image(systemName: symbolName)
            Text(label)
                .foregroundStyle(.black)
                .font(.custom("Marcellus-Regular", size: 18))
        }
        .padding()
        .frame(width: 160, height: 50)
        .overlay(
            RoundedRectangle(cornerRadius: 35)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [8]))
                .foregroundColor(.black)
        )
        .foregroundColor(.black)
    }
}

