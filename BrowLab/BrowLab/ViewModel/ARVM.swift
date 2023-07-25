//
//  ARVM.swift
//  BrowLab
//
//  Created by Wonil Lee on 2023/07/25.
//

import ARKit
import RealityKit

class ARVM: ObservableObject {
    @Published var arView = ARView(frame: .zero)
    @Published var configuration = ARFaceTrackingConfiguration()
    
    func setup() {
        if !ARFaceTrackingConfiguration.isSupported {
            print("Your device does not support face anchors!")
        } else {
            let configuration = ARFaceTrackingConfiguration()
            // disable face occlusion
            arView.renderOptions.insert(.disableFaceMesh)
        }
    }
    
    func start() {
        arView.session.run(configuration)
    }
    
    func stop() {
        arView.session.pause()
    }
}
