//
//  ViewModel.swift
//  photoPicker
//
//  Created by Печик Ирина on 02.02.2024.
//

import SwiftUI

class PhotoPickerViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var showPicker = false
    @Published var source: PhotoSourcePicker.Source = .library
    @Published var showCameraAlert = false
    @Published var cameraError: PhotoSourcePicker.CameraErrorType?
    @Published var myImages: [MyImage] = []
    @Published var isEditing = false
    @Published var showFileAlert = false
    @Published var appError: MyImageError.ErrorType?
    @Published var selectedImage: MyImage?


    init() {
        print(FileManager.docDirURL.path)
    }
    
    func showPhotoPicker() {
        do {
            if source == .camera {
                try PhotoSourcePicker.checkPermissions()
            }
            showPicker = true
        } catch {
            showCameraAlert = true
            cameraError = PhotoSourcePicker.CameraErrorType(error: error as! PhotoSourcePicker.PickerError)
        }
    }
    
    func display(_ myImage: MyImage) {
        image = myImage.image
        selectedImage = myImage
    }
    
    func reset() {
        image = nil
        isEditing = false
        selectedImage = nil
    }

    
    func addMyImage(_ name: String, image: UIImage) {
        reset()
        let myImage = MyImage(name: name)
        do {
            try FileManager().saveImage("\(myImage.id)", image: image)
            myImages.append(myImage)
            saveMyImagesJSONFile()
            reset()
        } catch {
            showFileAlert = true
            appError = MyImageError.ErrorType(error: error as! MyImageError)
        }
    }
    
    func saveMyImagesJSONFile() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(myImages)
            let jsonString = String(decoding: data, as: UTF8.self)
            reset()
            do {
                try FileManager().saveDocument(contents: jsonString)
            } catch {
                showFileAlert = true
                appError = MyImageError.ErrorType(error: error as! MyImageError)
            }
        } catch {
            showFileAlert = true
            appError = MyImageError.ErrorType(error: .encodingError)
        }
    }
    
    var buttonDisabled: Bool {
        image == nil
    }
    
    var deleteButtonIsHidden: Bool {
        isEditing || selectedImage == nil
    }

    func deleteSelected() {
        if let index = myImages.firstIndex(where: {$0.id == selectedImage!.id}) {
            myImages.remove(at: index)
            saveMyImagesJSONFile()
            reset()
        }
    }
    
    func updateSelected() {
        if let index = myImages.firstIndex(where: {$0.id == selectedImage!.id}) {
            saveMyImagesJSONFile()
            reset()
        }
    }

    func loadMyImagesJSONFile() {
        do {
            let data = try FileManager().readDocument()
            let decoder = JSONDecoder()
            do {
                myImages = try decoder.decode([MyImage].self, from: data)
            } catch {
                showFileAlert = true
                appError = MyImageError.ErrorType(error: .decodingError)
            }
        } catch {
            showFileAlert = true
            appError = MyImageError.ErrorType(error: error as! MyImageError)
        }
    }
}
