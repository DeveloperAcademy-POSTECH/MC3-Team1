//
//  BrowView.swift
//  BrowLab
//
//  Created by yun on 2023/07/25.
//

import SwiftUI

struct BrowView: View {
    @EnvironmentObject var arVM: ARVM
    @EnvironmentObject var personalizationModel: PersonalizationModel
    @State var modelIsShown = [String: Bool]()
    
    @State var isScanViewOpened : Bool = false
    
    let isScanned : Bool = UserDefaults.standard.bool(forKey: "isScanned")
    
    // initialize modelIsShown dictionary
    init() {
        var modelIsShown = [String: Bool]()
        for o in EyebrowAssetData.eyebrowNameArray {
            modelIsShown[o] = false
        }
        _modelIsShown = State(initialValue: modelIsShown)
    }
    
    // EyebrowAssetData에 따로 빼놨어요
    let options = EyebrowAssetData.eyebrowNameArray
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Spacer()
                    ZStack{
                        Button {
                            isScanViewOpened = true
                        } label: {
                            Image("faceScanIcon")
                            
                        }
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 42, height: 42)
                            .background(.gray)
                            .opacity(0.1)
                            .cornerRadius(10)
                            .padding()
                    }
                }
                
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
            .background(isScanViewOpened ? Color.black.opacity(0.5) : .clear)
            .transition(.opacity)
            
            // customize modal view
            
            if isScanViewOpened {
                GeometryReader { geometry in
                    ZStack{
                        Color(.gray)
                            .ignoresSafeArea()
                            .opacity(0.7)
                        
                        PopUpView(isScanViewOpened: $isScanViewOpened)
                            .frame(width: 330, height: 430) // Set the size of the
                            .background(.white)
                            .cornerRadius(10)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                }
               
            }
        }
        
    }
    func optionButtonTapped(_ option: String) {
        // Handle the selection of an option here
        if !(modelIsShown[option]!) {
            print("Selected option: \(option)")
            for o in EyebrowAssetData.eyebrowNameArray {
                modelIsShown[o] = false
            }
            // remove all before adding
            arVM.arView.scene.anchors.removeAll()
            
            // add the option
            modelIsShown[option] = true
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
                
                let scaleX: Float = (personalizationModel.eyebrowLengthDictionary[option] ?? personalizationModel.eyebrowLengthDictionary["Basic"]!) / originSize.x
                
                faceAnchor.right?.scale = SIMD3<Float>(repeating: scaleX)
                
                centerW = size[0]/2 * scaleX
                centerH = size[1]/2 * scaleX
                
                print("scaledW: \(centerW * 2.0)")
                
                let position = SIMD3<Float>(x: Float(centerW+personalizationModel.headX), y: 0.045, z: Float(centerH+personalizationModel.mountainZ))
                faceAnchor.right?.position = position
                
            } else{
                print("NOPE")
            }
            arVM.arView.scene.addAnchor(faceAnchor)
        }
        // when model is ON
        else {
            // remove all
            for o in EyebrowAssetData.eyebrowNameArray {
                modelIsShown[o] = false
            }
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
