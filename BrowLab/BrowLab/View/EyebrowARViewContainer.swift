//
//  EyebrowARViewContainer.swift
//  BrowLab
//
//  Created by Wonil Lee on 2023/07/25.
//

import SwiftUI
import ARKit
import RealityKit

struct EyebrowARViewContainer: UIViewRepresentable  {
    @EnvironmentObject var eyebrowARVM: EyebrowARVM
    
    func makeUIView(context: Context) -> ARView {
        let arView = eyebrowARVM.arView
        eyebrowARVM.stop()
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
