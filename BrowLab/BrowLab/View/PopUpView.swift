//
//  PopUpView.swift
//  BrowLab
//
//  Created by yun on 2023/07/26.
//

import SwiftUI

struct PopUpView: View {
    @Binding var isScanButtonTapped:Bool
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button {
                    isScanButtonTapped = false
                } label: {
                    Image("deleteIcon")
                }
                .padding(.trailing)
            }
            Text("페이스 스캔")
                .font(.system(size: 28))
                .bold()
            
            Spacer()
                .frame(height: 15)
            
            Text("얼굴에 정확히 맞아떨어지는 눈썹 가이드를\n제공하기 위해 페이스 스캔을 진행해요.")
                .font(.system(size: 14))
                
            
            Spacer()
                .frame(height: 20)
            
            
            Image("faceScan")
            
            Spacer()
                .frame(height: 20)

            Button {
                let _ = print("hello")
            } label: {
                Text("페이스 스캔하기")
                    .font(.system(size: 18))
                    .bold()
                    .frame(width: 300, height: 56)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            
        }
    }
}

//struct PopUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        PopUpView()
//    }
//}
