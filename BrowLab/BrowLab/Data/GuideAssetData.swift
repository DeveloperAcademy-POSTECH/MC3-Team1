//
//  GuideAssetData.swift
//  BrowLab
//
//  Created by Wonil Lee on 2023/07/25.
//

import Foundation

// This enum is not in use
enum GuideAssetData {
    // Need ratio of each assets to get personalized values
    
    // all names of guide
    static let guideNameArray = EyebrowAssetData.eyebrowNameArray
    
    // (v / h) ratio of each guide asset
    static let ratioDictionary: [String: Double] = [
        "Basic": basicRatio,
        "Option 1": 0.266,
        "Option 2": 0.276,
        "Option 3": 0.286,
        "Option 4": 0.296
    ]
    
    // ratio value to be used for invalid name
    static let basicRatio = 0.22
}
