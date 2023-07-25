//
//  BrowLabApp.swift
//  BrowLab
//
//  Created by doeun kim on 2023/07/13.
//

import SwiftUI
import Combine

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let captureSession = CaptureSession()
    let faceDetector = FaceDetector()
    
    var cancellables = [AnyCancellable]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        captureSession.$sampleBuffer
            .subscribe(faceDetector.subject).store(in: &cancellables)
        return true
    }
}

@main
struct BrowLabApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var covertedPoints: ConvertedPoints
    let camPermission = PermissionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.faceDetector)
                .environmentObject(appDelegate.captureSession)
        }.onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                if camPermission.isCameraAuthorized() {
                    appDelegate.captureSession.setup()
                    appDelegate.captureSession.start()
                    print("active, cam authorized")
                } else {
                    print("active, cam not authorized")
                }
            case .background:
                appDelegate.captureSession.stop()
                print("background")
            case .inactive:
                print("inactive")
            @unknown default:
                print("default")
            }
        }
    }
}
