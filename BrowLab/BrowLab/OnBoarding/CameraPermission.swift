//
//  CameraPermission.swift
//  BrowLab
//
//  Created by yun on 2023/07/24.

import AVFoundation
import UIKit
import SwiftUI

class PermissionManager : ObservableObject {
    @Published var permissionGranted = false
    
    /**
     * 카메라 권한을 요청합니다.
     */
    
    
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsURL)
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void){
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            DispatchQueue.main.async {
                completion(granted)
            }
            
        })
    }
    
    // check camera access granted or not
    func isCameraAuthorized() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return status == .authorized
    }
}
