//
//  ARViewContainer.swift
//  BrowLab
//
//  Created by Wonil Lee on 2023/07/25.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable  {
    @EnvironmentObject var arVM: ARVM
    
    func makeUIView(context: Context) -> ARView {
        let arView = arVM.arView
        arVM.setup()
        arVM.start()
        arView.session.delegate = context.coordinator
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
    }
}
