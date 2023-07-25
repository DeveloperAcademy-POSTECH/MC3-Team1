//
//  EyebrowAssetRatio.swift
//  formula code 2
//
//  Created by Wonil Lee on 2023/07/23.
//

import Foundation


enum EyebrowAssetData {
    
    // all names of eyebrow
    static let eyebrowNameArray = ["typeAThin", "typeAThick", "typeBThin", "typeBThick", "typeCThin", "typeCThick", "typeDThin", "typeDThin", "basic"]
    
    // (v / h) ratio of each eyebrow asset
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
