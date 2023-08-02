//
//  PopUpView.swift
//  BrowLab
//
//  Created by yun on 2023/07/26.
//

import SwiftUI

struct PopUpView: View {
    
    @Binding var isScanButtonTapped:Bool
    
    @State var isFirst = UserDefaults.standard.bool(forKey: "_isFirstLaunching")
    @State var isScanned = UserDefaults.standard.bool(forKey: "isScanned")
    
    @State var isVisionOpened = false
    
    @EnvironmentObject var faceDetector: FaceDetector
    @EnvironmentObject var captureSession: CaptureSession
    @EnvironmentObject var personalizationModel: PersonalizationModel
    
    
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button {
                    isScanButtonTapped = false
                } label: {
                    Image("deleteIcon")
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
               
            }
            Text("페이스 스캔")
                .font(.system(size: 28))
                .bold()
               
            
            Spacer()
                .frame(height: 15)
            
            Text("얼굴에 정확히 맞아떨어지는 눈썹 가이드를\n제공하기 위해 페이스 스캔을 진행해요.")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .foregroundColor(Color(hex: 0x585858))
            
            
            Spacer()
                .frame(height: 20)
            
            
            Image("faceScan")
            
            Spacer()
               
            
            Button {
                
                isVisionOpened = true
            } label: {
                Text("페이스 스캔하기")
                    .font(.system(size: 18))
                    .bold()
                    .frame(width: 300, height: 56)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            Spacer()
                .frame(height: 30)
            
        }
        .onChange(of: isVisionOpened) { (_) in
            if isVisionOpened == false{
                isScanButtonTapped = false
            }
        }
        .sheet(isPresented: $isVisionOpened) {
            
            VisionView(isFirst: $isFirst, isVisionOpened: $isVisionOpened)
                .environmentObject(faceDetector)
                .environmentObject(captureSession)
                .environmentObject(personalizationModel)
        }
        
    }
    
}

//struct PopUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        PopUpView()
//    }
//}
