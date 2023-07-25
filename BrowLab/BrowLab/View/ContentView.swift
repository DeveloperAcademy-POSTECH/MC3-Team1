//
//  ContentView.swift
//  BrowLab
//
//  Created by doeun kim on 2023/07/13.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true
    
    @State var isMain : Bool = false
    
    let camPermission = PermissionManager()
    
    var body: some View {

        if self.isMain{
            VisionView()
                .fullScreenCover(isPresented: $isFirstLaunching) {
                    OnBoardingViews(isFirstLaunching: $isFirstLaunching)
                }
        } else{
            SplashView()
                .transition(.opacity)
                .onAppear {
                    isFirstLaunching = !camPermission.isCameraAuthorized()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                        withAnimation{
                            self.isMain = true
                            
                        }
                    }
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
