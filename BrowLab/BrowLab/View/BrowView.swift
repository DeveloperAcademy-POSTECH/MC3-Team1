//
//  BrowView.swift
//  BrowLab
//
//  Created by yun on 2023/07/25.
//

import SwiftUI

struct BrowView: View {
    let options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    var body: some View {
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
    }
    func optionButtonTapped(_ option: String) {
        // Handle the selection of an option here
        print("Selected option: \(option)")
    }
}

struct BrowView_Previews: PreviewProvider {
    static var previews: some View {
        BrowView()
    }
}
