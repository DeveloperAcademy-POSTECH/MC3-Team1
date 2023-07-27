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
    
    // 선택한 눈썹 없으면 nil, 있으면 눈썹 이름
    // 눈썹이 띄워져 있는지 여부를 이 값의 nil/non-nil로 구분
    @State var chosenEyebrowName: String?
    // 스캔 버튼 탭하면 true로 바뀐다
    @State var isScanButtonTapped : Bool = false
    @State var isFullScreen: Bool = false
    
    let isScanned : Bool = UserDefaults.standard.bool(forKey: "isScanned")
    
    // EyebrowAssetData에 따로 빼놨어요
    let options = EyebrowAssetData.eyebrowNameArray
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.white)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .opacity(0.00001)
                // AR
                ARViewContainer()
                    .environmentObject(arVM)
                    .frame(width: isFullScreen ? UIScreen.main.bounds.width : UIScreen.main.bounds.width, height: isFullScreen ? UIScreen.main.bounds.height : UIScreen.main.bounds.width * 16.0 / 9.0)
                
                // choice button
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
                
                if chosenEyebrowName != nil {
                    VStack {
                        Spacer()
                            .frame(minHeight: 30, maxHeight: 84)
                        HStack{
                            Spacer()
                            ZStack{
                                NavigationLink(destination: GuideView(chosenEyebrowName: chosenEyebrowName ?? "Basic").environmentObject(arVM).environmentObject(personalizationModel)) {
                                    ZStack
                                    {
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 119, height: 42)
                                            .foregroundColor(.white)
                                            .opacity(0.8)
                                            .cornerRadius(12)
                                            .padding(12)
                                        Text("가이드 보기")
                                            .font(.title3)
                                    }
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
                VStack {
                    Spacer()
                    .frame(minHeight: 30, maxHeight: 84)
                    HStack{
                        Spacer()
                        Button {
                            isFullScreen.toggle()
                        } label: {
                            Text("Screen Style")
                        }
                        .buttonStyle(.bordered)
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
            }
            .onDisappear {
                arVM.stop()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
    }
    func optionButtonTapped(_ option: String) {
        // when tapped button is OFF now
        if option != (chosenEyebrowName ?? "") {
            print("Selected option: \(option)")
            chosenEyebrowName = option
            
            // remove all before adding
            arVM.arView.scene.anchors.removeAll()
            
            // add the option
            switch option {
                case "일자 눈썹":
                    arVM.addLinearEyebrow(personalizationModel: personalizationModel)
                case "둥근 눈썹":
                    arVM.addRoundEyebrow(personalizationModel: personalizationModel)
                case "아치형 눈썹":
                    arVM.addArchEyebrow(personalizationModel: personalizationModel)
                case "각진 눈썹":
                    arVM.addAngularEyebrow(personalizationModel: personalizationModel)
                default:
                    arVM.addSampleEyebrow(personalizationModel: personalizationModel)
            }
        }
        // when tapped button is already ON
        else {
            // remove all
            chosenEyebrowName = nil
            arVM.arView.scene.anchors.removeAll()
            print("removed")
        }
    }
}

struct BrowView_Previews: PreviewProvider {
    static var previews: some View {
        BrowView()
            .environmentObject(ARVM())
            .environmentObject(PersonalizationModel())
    }
}
