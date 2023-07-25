//
//  EyebrowAssetRatio.swift
//  formula code 2
//
//  Created by Wonil Lee on 2023/07/23.
//

import Foundation


enum EyebrowAssetData {
    // Need ratio of each assets to get personalized values
    
    // all names of eyebrow
    static let eyebrowNameArray = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    // (v / h) ratio of each eyebrow asset
    static let ratioDictionary: [String: Double] = [
        "Basic": basicRatio,
        "Option 1": 0.266,
        "Option 2": 0.276,
        "Option 3": 0.286,
        "Option 4": 0.296
    ]
    
    // ratio value to be used for invalid name
    static let basicRatio = 0.266
}
