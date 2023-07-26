//
//  FirstOnView.swift
//  BrowLab
//
//  Created by yun on 2023/07/24.
//

import SwiftUI

struct FirstOnView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack{
           Spacer()
            Text("나에게 꼭 맞는\n눈썹을 찾아보세요")
                .font(.system(size: 28))
                .bold()
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                
            
            Spacer()
                .frame(height: 30)
            
            Text("브로우랩에서 어떤 눈썹이 내게\n잘 어울리는지 확인하고 가이드를 따라\n원하는 눈썹을 쉽게 그려보세요.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
            
            Spacer()
                .frame(height: 60)
            
            Image("brow")
            
            Spacer()
            
            Button {
                selectedTab = 2
                
            } label: {
                Text("시작하기")
                    .font(.system(size: 18))
                    .bold()
                    .frame(width: 350, height: 56)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.bottom, 44)
        }
    }
}
