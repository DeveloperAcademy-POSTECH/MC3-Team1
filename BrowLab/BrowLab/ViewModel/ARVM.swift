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
    
    // 화면에 AR이 등장할 때 이니셜라이징을 하도록 유도하는 변수
    @Published var eyebrowARExists = false
    @Published var guideARExists = false
    // 앱이 .active 상태였을 때 어떤 화면이 appear 상태였는지 기록하는 변수. BrowLappApp.swift에서 사용한다.
    @Published var eyebrowARExistedInLastActive = false
    @Published var guideARExistedInLastActive = false
    
    func setup() {
        arView.cameraMode = .ar
        arView.renderOptions.insert(.disableFaceMesh)
    }
    
    func start() {
        arView.session.run(configuration)
    }
    
    func stop() {
        arView.session.pause()
    }
    
    //MARK: - arView에 scene을 추가하는 메서드
    func addLinearEyebrow(personalizationModel: PersonalizationModel) {
        let eyebrowNum = 0 // linear eyebrow
        let faceAnchor = try! Eyebrow.loadLinearScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = personalizationModel.eyebrowLengthArray[eyebrowNum] / originSize.x
            
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

    func addRoundEyebrow(personalizationModel: PersonalizationModel) {
        let eyebrowNum = 1 // round eyebrow
        let faceAnchor = try! Eyebrow.loadRoundScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = personalizationModel.eyebrowLengthArray[eyebrowNum] / originSize.x
            
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
    
    func addArchEyebrow(personalizationModel: PersonalizationModel) {
        let eyebrowNum = 2 // arch eyebrow
        let faceAnchor = try! Eyebrow.loadArchScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = personalizationModel.eyebrowLengthArray[eyebrowNum] / originSize.x
            
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
    
    func addAngularEyebrow(personalizationModel: PersonalizationModel) {
        let eyebrowNum = 3
        let faceAnchor = try! Eyebrow.loadAngularScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = personalizationModel.eyebrowLengthArray[eyebrowNum] / originSize.x
            
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
