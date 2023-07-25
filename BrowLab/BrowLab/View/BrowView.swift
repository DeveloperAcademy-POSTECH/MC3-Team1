//
//  BrowView.swift
//  BrowLab
//
//  Created by yun on 2023/07/25.
//

import SwiftUI

struct BrowView: View {
    @StateObject var arVM = ARVM()
    @StateObject var conversionModel = ConversionModel()
    
    @State var modelIsShown = false
    
    // EyebrowAssetData에 따로 빼놨어요
    let options = EyebrowAssetData.eyebrowNameArray
    
    var body: some View {
        ZStack {
            ARViewContainer()
                .environmentObject(arVM)
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                optionButtonTapped(option)
                            }) {
                                
                                ZStack{
                                    VStack{
                                        Image(systemName: "heart")
                                            .foregroundColor(.yellow)
                                        
                                        Text(option)
                                            .foregroundColor(.white)
                                        
                                    }
                                    .padding(.horizontal, 60)
                                    .padding(.vertical, 50)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                    
                                    
                                }
                                
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    func optionButtonTapped(_ option: String) {
        // Handle the selection of an option here
        print("Selected option: \(option)")
        
        if !modelIsShown {
            modelIsShown = true
            var faceAnchor = try! SampleEyebrow.loadScene()
            // load scene for given option
            switch option {
                case options[0]:
                    faceAnchor = try! SampleEyebrow.loadScene()
                default:
                    faceAnchor = try! SampleEyebrow.loadScene()
            }
            
            var centerW: Float
            var centerH: Float
            
            if let boundingBox = faceAnchor.right?.visualBounds(relativeTo: nil) {
                let size = boundingBox.extents
                let originSize = boundingBox.extents
                
                let scaleX: Float = conversionModel.eyebrowLengthDictionary[option] ?? conversionModel.eyebrowLengthDictionary["basic"]! / originSize.x
                
                faceAnchor.right?.scale = SIMD3<Float>(repeating: scaleX)
                
                centerW = size[0]/2 * scaleX
                centerH = size[1]/2 * scaleX
                
                let position = SIMD3<Float>(x: Float(centerW+conversionModel.headX), y: 0.05, z: Float(centerH+conversionModel.mountainZ))
                faceAnchor.right?.position = position
                
            } else{
                print("NOPE")
            }
            arVM.arView.scene.addAnchor(faceAnchor)
        }
        // when model is ON
        else {
            modelIsShown = false
            arVM.arView.scene.anchors.removeAll()
            print("removed")
        }
    }
}

struct BrowView_Previews: PreviewProvider {
    static var previews: some View {
        BrowView()
            .environmentObject(ARVM())
    }
}
