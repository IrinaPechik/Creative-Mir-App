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
    
    var text1: String {
        switch AuthService.shared.getUserRole() {
        case String(describing: UserRoles.supplier):
            return "Upload your"
        case String(describing: UserRoles.venue):
            return "Upload photos"
        default:
            return "Upload your"
        }
    }
    
    var text2: String {
        switch AuthService.shared.getUserRole() {
        case String(describing: UserRoles.supplier):
            return "photo from work"
        case String(describing: UserRoles.venue):
            return "of the place"
        default:
            return "photo from work"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
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
                
                NextButtonViewSecond(buttonText: "N E X T", isDisabled: vm.myImages.isEmpty) {
                    var imagesArray: [Data?] = []
                    for currentImage in vm.myImages {
                        var jpegImage = currentImage.image.jpegData(compressionQuality: 0.8)
                        imagesArray.append(jpegImage)
                    }
                    switch AuthService.shared.getUserRole() {
                        case String(describing: UserRoles.supplier):
                            print("saving supplier's photo")
                            AuthService.shared.saveSupplierPhotosFromWork(workPhotosJpeg: imagesArray)
                        DatabaseService.shared.setSupplier(supplier: MWSupplier(id: AuthService.shared.getUserId(), storyAboutYourself: AuthService.shared.getSupplierStoryAboutYourself(), legalStatus: AuthService.shared.getPerformerCompanyOrIndividualStatus(), stageName: AuthService.shared.getSupplierStageName(), companyName: AuthService.shared.getPerformerCompanyName(), companyPosition: AuthService.shared.getPerformerPositionInCompany(), skill: AuthService.shared.getSupplierFirstSkill(), experience: AuthService.shared.getSupplierFirstSkillExperience(), experienceMeasure: AuthService.shared.getSupplierFirstSkillExperienceMeasure(), storyAboutWork: AuthService.shared.getSupplierStoryAboutWork(), photosFromWork: AuthService.shared.getSupplierPhotosFromWork())) { result in
                            switch result {
                            case .success(_):
                                presentNextView.toggle()
                            case .failure(let error):
                                showErrorAlert.toggle()
                                self.error = error.localizedDescription
                            }
                        }
                        case String(describing: UserRoles.venue):
                            presentNextView.toggle()

                            AuthService.shared.saveVenuePhotosOfThePlace(photosOfThePlaceJpeg: imagesArray)
                            print("saving venue's photo")
                        default:
                            presentNextView.toggle()

                            AuthService.shared.saveVenuePhotosOfThePlace(photosOfThePlaceJpeg: imagesArray)
                            print("photo saving error")
                    }
//                    presentNextView.toggle()
                }
            }
            .navigationDestination(isPresented: $presentNextView) {
                Text("next view")
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
