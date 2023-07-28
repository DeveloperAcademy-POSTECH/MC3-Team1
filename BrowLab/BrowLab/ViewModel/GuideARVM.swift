//
//  GuideARVM.swift
//  BrowLab
//
//  Created by Wonil Lee on 2023/07/25.
//

import ARKit
import RealityKit

class GuideARVM: ObservableObject {
    @Published var arView = ARView(frame: .zero)
    @Published var session = ARSession()
    @Published var configuration = ARFaceTrackingConfiguration()
    
    init() {
        arView.session = session
        // 가상의 마스크가 occlusion(가리기)을 하지 않게 설정
        arView.renderOptions.insert(.disableFaceMesh)
    }
    
    func start() {
        print("GuideARVM | start")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.session.run(self.session.configuration ?? self.configuration)
        }
    }
    
    func stop() {
        print("GuideARVM | stop")
        session.pause()
    }
    
    //MARK: - arView에 scene을 추가하는 메서드
    func addLinearGuide(personalizationModel: PersonalizationModel) {
        let guideNum = 0 // linear guide
        let faceAnchor = try! Guide.loadLinearScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = personalizationModel.eyebrowLengthArray[guideNum] / originSize.x
            
            faceAnchor.right?.scale = SIMD3<Float>(repeating: scaleX)
            faceAnchor.left?.scale = SIMD3<Float>(repeating: scaleX)
            
            centerW = size[0]/2 * scaleX
            centerH = size[1]/2 * scaleX
            
            let rightPosition = SIMD3<Float>(x: Float(centerW+personalizationModel.headX), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
            let leftPosition = SIMD3<Float>(x: Float(-(centerW+personalizationModel.headX)), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
            faceAnchor.right?.position = rightPosition
            faceAnchor.left?.position = leftPosition
            
        } else{
            print("NOPE")
        }
        arView.scene.addAnchor(faceAnchor)
    }

    func addRoundGuide(personalizationModel: PersonalizationModel) {
        let guideNum = 1 // round guide
        let faceAnchor = try! Guide.loadRoundScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = personalizationModel.eyebrowLengthArray[guideNum] / originSize.x
            
            faceAnchor.right?.scale = SIMD3<Float>(repeating: scaleX)
            faceAnchor.left?.scale = SIMD3<Float>(repeating: scaleX)
            
            centerW = size[0]/2 * scaleX
            centerH = size[1]/2 * scaleX
            
            let rightPosition = SIMD3<Float>(x: Float(centerW+personalizationModel.headX), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
            let leftPosition = SIMD3<Float>(x: Float(-(centerW+personalizationModel.headX)), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
            faceAnchor.right?.position = rightPosition
            faceAnchor.left?.position = leftPosition
            
        } else{
            print("NOPE")
        }
        arView.scene.addAnchor(faceAnchor)
    }
    
    func addArchGuide(personalizationModel: PersonalizationModel) {
        let guideNum = 2 // arch guide
        let faceAnchor = try! Guide.loadArchScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = personalizationModel.eyebrowLengthArray[guideNum] / originSize.x
            
            faceAnchor.right?.scale = SIMD3<Float>(repeating: scaleX)
            faceAnchor.left?.scale = SIMD3<Float>(repeating: scaleX)
            
            centerW = size[0]/2 * scaleX
            centerH = size[1]/2 * scaleX
            
            let rightPosition = SIMD3<Float>(x: Float(centerW+personalizationModel.headX), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
            let leftPosition = SIMD3<Float>(x: Float(-(centerW+personalizationModel.headX)), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
            faceAnchor.right?.position = rightPosition
            faceAnchor.left?.position = leftPosition
            
        } else{
            print("NOPE")
        }
        arView.scene.addAnchor(faceAnchor)
    }
    
    func addAngularGuide(personalizationModel: PersonalizationModel) {
        let guideNum = 3
        let faceAnchor = try! Guide.loadAngularScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = personalizationModel.eyebrowLengthArray[guideNum] / originSize.x
            
            faceAnchor.right?.scale = SIMD3<Float>(repeating: scaleX)
            faceAnchor.left?.scale = SIMD3<Float>(repeating: scaleX)
            
            centerW = size[0]/2 * scaleX
            centerH = size[1]/2 * scaleX
            
            let rightPosition = SIMD3<Float>(x: Float(centerW+personalizationModel.headX), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
            let leftPosition = SIMD3<Float>(x: Float(-(centerW+personalizationModel.headX)), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
            faceAnchor.right?.position = rightPosition
            faceAnchor.left?.position = leftPosition
            
        } else{
            print("NOPE")
        }
        arView.scene.addAnchor(faceAnchor)
    }

}
