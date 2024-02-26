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
}
