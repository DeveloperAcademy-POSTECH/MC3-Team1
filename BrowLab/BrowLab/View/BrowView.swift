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
    
    // 선택한 눈썹 없으면 nil, 있으면 눈썹 번호
    // 눈썹이 띄워져 있는지 여부를 이 값의 nil/non-nil로 구분
    @State var chosenEyebrowNum: Int?
    // 스캔 버튼 탭하면 true로 바뀐다
    @State var isScanButtonTapped : Bool = false
    @State var isFullScreen: Bool = false
    
    let isScanned : Bool = UserDefaults.standard.bool(forKey: "isScanned")
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.white)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .opacity(0.00001)
                // AR
                VStack(spacing: 0) {
                    Group {
                        Spacer()
                            .frame(height: isFullScreen ? 0.0 : 84.0 / 852.0 * UIScreen.main.bounds.height)
                        // ARViewContainer를 초기화할 때 카메라의 주도권을 가져오는 점에서 힌트를 얻어서 if문 안에 ARViewContainer()를 가뒀다.
                        if arVM.eyebrowARExists {
                            ARViewContainer()
                                .environmentObject(arVM)
                        }
                        Spacer()
                            .frame(height: isFullScreen ? 0.0 : 67.0 / 852.0 * UIScreen.main.bounds.height)
                    }
                }
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 96.0 / 852.0 * UIScreen.main.bounds.height)
                    ZStack {
                        HStack{
                            Spacer()
                            // face scan button
                            ZStack{
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 42, height: 42)
                                    .foregroundColor(.white)
                                    .opacity(0.8)
                                    .padding(.horizontal, 12)
                                Button {
                                    isScanButtonTapped = true
                                } label: {
                                    Image("faceScanIcon")
                                }
                            }
                        }
                        // see-guide button
                        if chosenEyebrowNum != nil {
                            HStack {
                                Spacer()
                                ZStack {
                                    NavigationLink(destination: GuideView(chosenEyebrowNum: chosenEyebrowNum ?? 0, isFullScreen: isFullScreen).environmentObject(arVM).environmentObject(personalizationModel)) {
                                        ZStack
                                        {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: 119, height: 42)
                                                .foregroundColor(.white)
                                                .opacity(0.75)
                                                .padding(.horizontal, 12)
                                            Text("가이드 보기")
                                                .font(.title3)
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                    
                    // change-screen-ratio button
                    HStack {
                        Spacer()
                        Button {
                            isFullScreen.toggle()
                        } label: {
                            Image(systemName: isFullScreen ? "arrow.down.right.and.arrow.up.left.circle.fill" : "arrow.up.left.and.arrow.down.right.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .foregroundColor(.white)
                                .opacity(0.8)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 40.0 / 852.0 * UIScreen.main.bounds.height)
                    
                    // choice buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<EyebrowAssetData.nameArray.count, id: \.self) { iterator in
                                Button(action: {
                                    optionButtonTapped(iterator)
                                }) {
                                    
                                    ZStack{
                                        VStack{
                                            Image(systemName: "heart")
                                                .foregroundColor(.yellow)
                                            
                                            Text(EyebrowAssetData.nameArray[iterator])
                                                .foregroundColor(.white)
                                            
                                        }
                                        .frame(width: 130, height: 125)
                                        .background(.blue)
                                        .cornerRadius(8)
                                    }
                                    
                                }
                            }
                        }
                    }
                    Spacer()
                        .frame(height: 83.0 / 852.0 * UIScreen.main.bounds.height)
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
            .ignoresSafeArea()
            .onAppear {
                print("BrowView | onAppear-ing")
                arVM.eyebrowARExists = true
                arVM.arView.scene.anchors.removeAll()
                if let chosenEyebrowNum {
                    switch chosenEyebrowNum {
                        case 0:
                            arVM.addLinearEyebrow(personalizationModel: personalizationModel)
                        case 1:
                            arVM.addRoundEyebrow(personalizationModel: personalizationModel)
                        case 2:
                            arVM.addArchEyebrow(personalizationModel: personalizationModel)
                        case 3:
                            arVM.addAngularEyebrow(personalizationModel: personalizationModel)
                        default:
                            arVM.addLinearEyebrow(personalizationModel: personalizationModel)
                    }
                }
            }
            .onDisappear {
                arVM.eyebrowARExists = false
            }
        }
    }
    func optionButtonTapped(_ num: Int) {
        // when tapped button is OFF now
        if num != chosenEyebrowNum ?? -1 {
            print("Selected option: \(EyebrowAssetData.nameArray[num])")
            chosenEyebrowNum = num
            
            // remove all before adding
            arVM.arView.scene.anchors.removeAll()
            
            // add the option
            switch num {
                case 0:
                    arVM.addLinearEyebrow(personalizationModel: personalizationModel)
                case 1:
                    arVM.addRoundEyebrow(personalizationModel: personalizationModel)
                case 2:
                    arVM.addArchEyebrow(personalizationModel: personalizationModel)
                case 3:
                    arVM.addAngularEyebrow(personalizationModel: personalizationModel)
                default:
                    arVM.addLinearEyebrow(personalizationModel: personalizationModel)
            }
        }
        // when tapped button is already ON
        else {
            // remove all
            chosenEyebrowNum = nil
            arVM.arView.scene.anchors.removeAll()
            print("removed")
        }
    }
}
//
//struct BrowView_Previews: PreviewProvider {
//    static var previews: some View {
//        BrowView()
//            .environmentObject(ARVM())
//            .environmentObject(PersonalizationModel())
//    }
//}
