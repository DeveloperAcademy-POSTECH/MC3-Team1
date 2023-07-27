//
//  ThirdOnView.swift
//  BrowLab
//
//  Created by yun on 2023/07/24.
//

import SwiftUI
import AVFoundation

struct ThirdOnView: View {
  //  @Binding var selectedTab: Int
    @Binding var isFirstLaunching: Bool

    @State private var permissionRejected = false
    
    @StateObject var cameraAcess = PermissionManager()
    
    
    var body: some View {
        VStack{
            Spacer()
            Text("필터와 가이드 제공을 위해\n카메라 접근 허용이 필요해요")
                .font(.system(size: 28))
                .bold()
                .multilineTextAlignment(.center)
                .lineSpacing(5)
            
            Spacer()
                .frame(height: 30)
            
            Text("내 얼굴에 정확히 맞춘 눈썹 필터와 가이드를\n제공하기 위해 카메라를 사용해요.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
            
            Spacer()
                .frame(height: 60)
            
            Image("cam")
            Spacer()
            
            Button {
                cameraAcess.checkCameraPermission { granted in
                    if granted{
                        print("Camera: 권한 허용")
                        isFirstLaunching = false
                       // selectedTab = 4
                        
                    }else{
                        permissionRejected = true
                    }
                }
            } label: {
                Text("허용하기")
                    .font(.system(size: 18))
                    .bold()
                    .frame(width: 350, height: 56)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.bottom, 44)
            .alert(isPresented: $permissionRejected) {
                Alert(
                    title: Text("카메라 접근이 거부되었습니다."),
                    message: Text("환경설정에서 카메라 접근을 허용해주세요."),
                    primaryButton: .default(Text("환경설정"), action: {
                        cameraAcess.openAppSettings()
                    }),
                    secondaryButton: .cancel(Text("취소"))
                )
            }
        }
    }
}


//struct ThirdOnView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThirdOnView()
//    }
//}
