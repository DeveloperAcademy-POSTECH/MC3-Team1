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
            configuration = ARFaceTrackingConfiguration()
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
    
    //MARK: - arView에 scene을 추가하는 메서드들
    // 복붙 코드 여러 개로 관리하기 싫어서 고민을 해보았지만 rcproject의 scene과 하위의 앵커 등의 타입명이 모두 제각각이라 코드로 한번에 처리할 수가 없었다. 이게 최선이라는 결론에 이르렀다.
    func addSampleEyebrow(personalizationModel: PersonalizationModel) {
        let faceAnchor = try! SampleEyebrow.loadScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = personalizationModel.eyebrowLengthDictionary["Basic"]! / originSize.x
            
            faceAnchor.right?.scale = SIMD3<Float>(repeating: scaleX)
            
            centerW = size[0]/2 * scaleX
            centerH = size[1]/2 * scaleX
            
            let position = SIMD3<Float>(x: Float(centerW+personalizationModel.headX), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
            faceAnchor.right?.position = position
            
        } else{
            print("NOPE")
        }
        arView.scene.addAnchor(faceAnchor)
    }
    
    func addLinearEyebrow(personalizationModel: PersonalizationModel) {
        let faceAnchor = try! LinearEyebrow.loadScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = (personalizationModel.eyebrowLengthDictionary["일자 눈썹"] ?? personalizationModel.eyebrowLengthDictionary["Basic"]!) / originSize.x
            
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
        let faceAnchor = try! RoundEyebrow.loadScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = (personalizationModel.eyebrowLengthDictionary["둥근 눈썹"] ?? personalizationModel.eyebrowLengthDictionary["Basic"]!) / originSize.x
            
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
        let faceAnchor = try! ArchEyebrow.loadScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = (personalizationModel.eyebrowLengthDictionary["아치형 눈썹"] ?? personalizationModel.eyebrowLengthDictionary["Basic"]!) / originSize.x
            
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
        let faceAnchor = try! AngularEyebrow.loadScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = (personalizationModel.eyebrowLengthDictionary["각진 눈썹"] ?? personalizationModel.eyebrowLengthDictionary["Basic"]!) / originSize.x
            
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
    
    func addSampleGuide(personalizationModel: PersonalizationModel) {
        let faceAnchor = try! SampleGuide.loadScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = personalizationModel.eyebrowLengthDictionary["Basic"]! / originSize.x
            
            faceAnchor.right?.scale = SIMD3<Float>(repeating: scaleX)
            
            centerW = size[0]/2 * scaleX
            centerH = size[1]/2 * scaleX
            
            let position = SIMD3<Float>(x: Float(centerW+personalizationModel.headX), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
            faceAnchor.right?.position = position
            
        } else{
            print("NOPE")
        }
        arView.scene.addAnchor(faceAnchor)
    }
    
    func addLinearGuide(personalizationModel: PersonalizationModel) {
        let faceAnchor = try! LinearGuide.loadScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = (personalizationModel.eyebrowLengthDictionary["일자 눈썹"] ?? personalizationModel.eyebrowLengthDictionary["Basic"]!) / originSize.x
            
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
        let faceAnchor = try! RoundGuide.loadScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = (personalizationModel.eyebrowLengthDictionary["둥근 눈썹"] ?? personalizationModel.eyebrowLengthDictionary["Basic"]!) / originSize.x
            
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
        let faceAnchor = try! ArchGuide.loadScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = (personalizationModel.eyebrowLengthDictionary["아치형 눈썹"] ?? personalizationModel.eyebrowLengthDictionary["Basic"]!) / originSize.x
            
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
        let faceAnchor = try! AngularGuide.loadScene()
        
        var centerW: Float
        var centerH: Float
        
        if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
            let size = boundingBox.extents
            let originSize = boundingBox.extents
            
            let scaleX: Float = (personalizationModel.eyebrowLengthDictionary["각진 눈썹"] ?? personalizationModel.eyebrowLengthDictionary["Basic"]!) / originSize.x
            
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
