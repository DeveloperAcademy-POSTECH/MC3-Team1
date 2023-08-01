//
//  EyebrowAssetRatio.swift
//  formula code 2
//
//  Created by Wonil Lee on 2023/07/23.
//

import Foundation

// **** 눈썹의 회전은 코드로 관리하지 않고 리얼리티 컴포저로 직접 다루고 있습니다.

enum EyebrowAssetData {
    // Need ratio of each assets to get personalized values
    
    // all names of eyebrow
    static let nameArray = ["일자 눈썹", "둥근 눈썹", "틸트 눈썹", "각진 눈썹"]
    
    static let rightImageNameArray = ["straight_right", "arch_right", "tilt_right", "square_right"]
    
    // (v / h) ratio of each eyebrow asset
    static let ratioArray: [Double] = [
        0.2141, // 일자
        0.2659, // 둥근
        0.2447, // 아치형
        0.44  // 각진
    ]
    
    // ratio value to be used for invalid name
    static let basicRatio = 0.266
}
