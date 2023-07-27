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
    let arVM = ARVM()
    let personalizationModel = PersonalizationModel()
    
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
    @State var isInactiveFromBackground = true
    @State var wasCaptureSessionRunningwhenAppWasActive = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.faceDetector)
                .environmentObject(appDelegate.captureSession)
                .environmentObject(appDelegate.arVM)
                .environmentObject(appDelegate.personalizationModel)
        }.onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
                case .active:
                    // AR
                    appDelegate.arVM.eyebrowARExists = appDelegate.arVM.eyebrowARExistedInLastActive
                    appDelegate.arVM.guideARExists = appDelegate.arVM.guideARExistedInLastActive
                    // Vision
                    // 직전의 active 화면에서 Vision을 사용하고 있는었지를 변수로 저장해놓고 아래의 if문의 조건문에 &&로 추가했다.
                    if appDelegate.captureSession.cameraViewExistedInLastActive {
                        appDelegate.captureSession.cameraViewExists = true
                        if camPermission.isCameraAuthorized() {
                            appDelegate.captureSession.setup()
                            appDelegate.captureSession.start()
                            print("active, cam authorized")
                        } else {
                            print("active, cam not authorized")
                        }
                    } else {
                        print("active without Vision")
                    }
                    
                case .background:
                    isInactiveFromBackground = true
                    appDelegate.captureSession.stop()
                    print("background")
                case .inactive:
                    if isInactiveFromBackground {
                        isInactiveFromBackground = false
                    } else {
                        // AR
                        appDelegate.arVM.eyebrowARExistedInLastActive = appDelegate.arVM.eyebrowARExists
                        appDelegate.arVM.guideARExistedInLastActive = appDelegate.arVM.guideARExists
                        appDelegate.arVM.eyebrowARExists = false
                        appDelegate.arVM.guideARExists = false
                        // Vision
                        if appDelegate.captureSession.cameraViewExists {
                            appDelegate.captureSession.cameraViewExistedInLastActive = true
                            appDelegate.captureSession.stop()
                        }
                        appDelegate.captureSession.cameraViewExists = false
                    }
                    print("inactive")
                @unknown default:
                    print("default")
            }
        }
    }
}
