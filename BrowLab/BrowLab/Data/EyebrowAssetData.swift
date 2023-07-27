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
    static let eyebrowNameArray = ["일자 눈썹", "둥근 눈썹", "아치형 눈썹", "각진 눈썹"]
    
    // (v / h) ratio of each eyebrow asset
    static let ratioDictionary: [String: Double] = [
        "Basic": basicRatio,
        "일자 눈썹": 0.2482,
        "둥근 눈썹": 0.3382,
        "아치형 눈썹": 0.3394,
        "각진 눈썹": 0.3321
    ]
    
    // ratio value to be used for invalid name
    static let basicRatio = 0.266
}
