//
//  MatchingBrowVM.swift
//  BrowLab
//
//  Created by doeun kim on 2023/07/31.
//

import UIKit

// 이미지내 픽셀의 색상 변환 후 이미지 데이터로 전달
func MatchingBrowColor(color: UIColor) -> Int? {

    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    // ui color 값 받아오기
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    let rgbaColor = RGBA32(red: UInt8(red * 255), green: UInt8(green * 255), blue: UInt8(blue * 255), alpha: 255)
    
    let model1 = RGBA32(red: 62, green: 52, blue: 53, alpha: 255)
    let model2 = RGBA32(red: 88, green: 70, blue: 56, alpha: 255)
    let model3 = RGBA32(red: 140, green: 96, blue: 69, alpha: 255)
    let model4 = RGBA32(red: 239, green: 183, blue: 100, alpha: 255)
    
    let minNum = min(min(diffColor(color1: model1, color2: rgbaColor), diffColor(color1: model2, color2: rgbaColor)), min(diffColor(color1: model3, color2: rgbaColor), diffColor(color1: model4, color2: rgbaColor)))
    
    if(minNum == diffColor(color1: model1, color2: rgbaColor)){
        return 1
    }
    else if(minNum == diffColor(color1: model2, color2: rgbaColor)){
        return 2
    }
    else if(minNum == diffColor(color1: model3, color2: rgbaColor)){
        return 3
    }
    else{
        return 4
    }
}


func diffColor(color1: RGBA32, color2: RGBA32) -> Int {
    let redDiff = Int(color1.redComponent) - Int(color2.redComponent)
    let greenDiff = Int(color1.greenComponent) - Int(color2.greenComponent)
    let blueDiff = Int(color1.blueComponent) - Int(color2.blueComponent)
    return abs(redDiff) + abs(greenDiff) + abs(blueDiff)
}
