//
//  GuideAssetData.swift
//  BrowLab
//
//  Created by Wonil Lee on 2023/07/25.
//

import Foundation

// **** This enum is not in use
enum GuideAssetData {
    // Need ratio of each assets to get personalized values
    
    // all names of eyebrow
    static let nameArray = EyebrowAssetData.nameArray
    
    // (v / h) ratio of each eyebrow asset
    static let ratioArray: [Double] = [
        0.2482, // 일자
        0.3382, // 둥근
        0.3394, // 아치형
        0.3321  // 각진
    ]
    
    // ratio value to be used for invalid name
    static let basicRatio = 0.266
}
