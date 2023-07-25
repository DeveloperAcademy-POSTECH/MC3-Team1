//
//  GuideAssetData.swift
//  BrowLab
//
//  Created by Wonil Lee on 2023/07/25.
//

import Foundation

enum GuideAssetData {
    
    // all names of guide
    static let guideNameArray = EyebrowAssetData.eyebrowNameArray
    
    // (v / h) ratio of each guide asset
    static let ratioDictionary: [String: Double] = [
        "typeAThin": 0.18,
        "typeAThick": 0.20,
        
        "typeBThin": 0.20,
        "typeBThick": 0.22,
        
        "typeCThin": 0.22,
        "typeCThick": 0.24,
        
        "typeDThin": 0.22,
        "typeDThick": 0.24,
        
        "basic": basicRatio
    ]
    
    // ratio value to be used for invalid name
    static let basicRatio = 0.22
}
