//
//  OnBoardingViews.swift
//  BrowLab
//
//  Created by yun on 2023/07/24.
//

import SwiftUI



struct OnBoardingViews: View {
    @Binding var isFirstLaunching: Bool
    @State private var selectedTab: Int = 1
    
    
    var body: some View {
        
        TabNavigation(selectedTab: $selectedTab) {
            FirstOnView(selectedTab: $selectedTab)
                .tag(1)
            
            SecondOnView(selectedTab: $selectedTab, isFirst: $isFirstLaunching)
                .tag(2)
            
            ThirdOnView(selectedTab: $selectedTab, isFirst: $isFirstLaunching)
                .tag(3)
        } 
    }
}


struct TabNavigation<Content: View>: View {
    @Binding var selectedTab: Int
    var content: Content
    
    init(selectedTab: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selectedTab = selectedTab
        self.content = content()
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            content
        }
    }
}



//
//struct OnBoardingViews_Previews: PreviewProvider {
//    static var previews: some View {
//        OnBoardingViews(isFirstLaunching: isFirstLaunching)
//    }
//}
