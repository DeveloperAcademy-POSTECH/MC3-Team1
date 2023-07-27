//
//  GuideView.swift
//  BrowLab
//
//  Created by yun on 2023/07/25.
//

import SwiftUI

struct GuideView: View {
    @EnvironmentObject var arVM: ARVM
    @EnvironmentObject var personalizationModel: PersonalizationModel
    
    
    // 눈썹 이름
    var chosenEyebrowName: String
    
    // 스캔 버튼 탭하면 true로 바뀐다
    @State var isScanButtonTapped : Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    let isScanned : Bool = UserDefaults.standard.bool(forKey: "isScanned")
    
    // EyebrowAssetData에 따로 빼놨어요
    let options = EyebrowAssetData.eyebrowNameArray
    
    var body: some View {
        ZStack {
            // AR
            ARViewContainer()
                .environmentObject(arVM)
            
            VStack {
                // go-back-to-filter button
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 82, height: 42)
                            .foregroundColor(.white) // ?
                            .opacity(0.8) // ?
                            .cornerRadius(12)
                            .padding(12)
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Group {
                                    Image(systemName: "chevron.left")
                                    Text("필터")
                                }
                                .foregroundColor(Color.blue) // 커스텀 컬러가 오류가 나서 일단 블루
                            }
                        }
                    }
                    Spacer()
                    
                    // face scan button
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 42, height: 42)
                            .foregroundColor(.white)
                            .opacity(0.8)
                            .cornerRadius(12)
                            .padding(12)
                        Button {
                            isScanButtonTapped = true
                        } label: {
                            Image("faceScanIcon")
                                .foregroundColor(Color.blue) // 커스텀 컬러가 오류를 일으켜서 일단 블루
                        }
                    }
                }
                Spacer()
            }
            
            // customize modal view
            if isScanButtonTapped {
                GeometryReader { geometry in
                    ZStack{
                        Color(.gray)
                            .ignoresSafeArea()
                            .opacity(0.7)
                        
                        PopUpView(isScanButtonTapped: $isScanButtonTapped)
                            .frame(width: 330, height: 430) // Set the size of the
                            .background(.white)
                            .cornerRadius(10)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                }
                
            }
        }
        .onAppear {
            arVM.setup()
            arVM.start()
            switch chosenEyebrowName {
                case "일자 눈썹":
                    arVM.addLinearGuide(personalizationModel: personalizationModel)
                case "둥근 눈썹":
                    arVM.addRoundGuide(personalizationModel: personalizationModel)
                case "아치형 눈썹":
                    arVM.addArchGuide(personalizationModel: personalizationModel)
                case "각진 눈썹":
                    arVM.addAngularGuide(personalizationModel: personalizationModel)
                default:
                    arVM.addSampleGuide(personalizationModel: personalizationModel)
            }
        }
        .onDisappear {
            arVM.arView.scene.anchors.removeAll()
            arVM.stop()
        }
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GuideView(chosenEyebrowName: "일자 눈썹")
            .environmentObject(ARVM())
            .environmentObject(PersonalizationModel())
    }
}
