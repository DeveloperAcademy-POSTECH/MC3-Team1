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
    
    
    // 눈썹 번호
    var chosenEyebrowNum: Int
    var isFullScreen: Bool = false
    
    // 스캔 버튼 탭하면 true로 바뀐다
    @State var isScanButtonTapped : Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    let isScanned : Bool = UserDefaults.standard.bool(forKey: "isScanned")
    
    var body: some View {
        ZStack {
            Color(.white)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .opacity(0.00001)
            // AR
            VStack(spacing: 0) {
                Group {
                    Spacer()
                        .frame(height: isFullScreen ? 0.0 : 84.0 / 852.0 * UIScreen.main.bounds.height)
                    ARViewContainer()
                        .environmentObject(arVM)
                    Spacer()
                        .frame(height: isFullScreen ? 0.0 : 67.0 / 852.0 * UIScreen.main.bounds.height)
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 96.0 / 852.0 * UIScreen.main.bounds.height)

                HStack(spacing: 0){
                    Spacer()
                        .frame(width: 12)
                    // go-back-to-filter button
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 82, height: 42)
                            .foregroundColor(.white)
                            .opacity(0.8)
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Group {
                                    Image(systemName: "chevron.left")
                                    Text("필터")
                                        .font(.title3)
                                }
                                .foregroundColor(Color.blue) // 커스텀 컬러가 오류가 나서 일단 블루
                            }
                        }
                    }
                    Spacer()
                    
                    // face scan button
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 42, height: 42)
                            .foregroundColor(.white)
                            .opacity(0.8)
                        Button {
                            isScanButtonTapped = true
                        } label: {
                            Image("faceScanIcon")
                                .foregroundColor(Color.blue) // 커스텀 컬러가 오류를 일으켜서 일단 블루
                        }
                    }
                    Spacer()
                        .frame(width: 12)
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
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            print("GuideView | onAppear-ing")
            arVM.arView.scene.anchors.removeAll()
            switch chosenEyebrowNum {
                case 0:
                    arVM.addLinearGuide(personalizationModel: personalizationModel)
                case 1:
                    arVM.addRoundGuide(personalizationModel: personalizationModel)
                case 2:
                    arVM.addArchGuide(personalizationModel: personalizationModel)
                case 3:
                    arVM.addAngularGuide(personalizationModel: personalizationModel)
                default:
                    arVM.addLinearGuide(personalizationModel: personalizationModel)
            }
        }
        .onDisappear {
        }
    }
}

//struct GuideView_Previews: PreviewProvider {
//    static var previews: some View {
//        GuideView(chosenEyebrowName: "일자 눈썹", isFullScreen: false)
//            .environmentObject(ARVM())
//            .environmentObject(PersonalizationModel())
//    }
//}
