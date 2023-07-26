//
//  SecondOnView.swift
//  BrowLab
//
//  Created by yun on 2023/07/24.
//

import SwiftUI
import AVFoundation

struct SecondOnView: View {
    @Binding var selectedTab: Int
    
    @State private var permissionRejected = false
    
    @StateObject var cameraAcess = PermissionManager()
    
    var body: some View {
        VStack{
            Spacer()
            Text("페이스 스캔으로\n내 얼굴에 맞춰요")
                .font(.system(size: 28))
                .bold()
                .multilineTextAlignment(.center)
                .lineSpacing(5)
            
            Spacer()
                .frame(height: 30)
            
            Text("어떤 각도에서 봐도 완벽하게.\n내 얼굴에 정확히 맞아떨어지는 눈썹 가이드를\n제공하기 위해 페이스 스캔을 진행해요. ")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
            
            Spacer()
                .frame(height: 60)
            
            Image("faceScan")
            Spacer()
            
            Button {
                cameraAcess.checkCameraPermission { granted in
                    if granted{
                        print("Camera: 권한 허용")
                        selectedTab = 4
                    }else{
                        permissionRejected = true
                    }
                    
                }
            } label: {
                Text("페이스 스캔하기")
                    .font(.system(size: 18))
                    .bold()
                    .frame(width: 350, height: 56)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            
            Button {
                selectedTab = 3
                UserDefaults.standard.set(false, forKey: "isScanned")
            } label: {
                Text("나중에 스캔하기")
                    .font(.system(size: 18))
                    .bold()
                    .frame(width: 350, height: 56)
                    .foregroundColor(.blue)
                    .cornerRadius(12)
            }
            .padding(.bottom, 22)
            .alert(isPresented: $permissionRejected) {
                Alert(
                    title: Text("카메라 접근이 거부되었습니다."),
                    message: Text("환경설정에서 카메라 접근을 허용해주세요."),
                    primaryButton: .default(Text("환경설정"), action: {
                        cameraAcess.openAppSettings()
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

//struct SecondOnView_Previews: PreviewProvider {
//    static var previews: some View {
//        SecondOnView()
//    }
//}
