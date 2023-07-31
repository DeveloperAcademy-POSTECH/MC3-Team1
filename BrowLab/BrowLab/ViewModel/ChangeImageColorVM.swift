//
//  ChangeImageColorVM.swift
//  BrowLab
//
//  Created by doeun kim on 2023/07/27.
//

import UIKit

// 현재
// 이미지내 픽셀의 색상 변환
func processPixels(in image: UIImage) -> String? {
    guard let inputCGImage = image.cgImage else {
        print("[Error] unable to get cgImage")
        return nil
    }
    
    let colorSpace       = CGColorSpaceCreateDeviceRGB()
    let width            = inputCGImage.width
    let height           = inputCGImage.height
    let bytesPerPixel    = 4
    let bitsPerComponent = 8
    let bytesPerRow      = bytesPerPixel * width
    let bitmapInfo       = RGBA32.bitmapInfo

    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
        print("[Error] unable to create context")
        return nil
    }
    context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

    guard let buffer = context.data else {
        print("[Error] unable to get context data")
        return nil
    }

    let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

    for row in 0 ..< Int(height) {
        for column in 0 ..< Int(width) {
            let offset = row * width + column
            if(pixelBuffer[offset].alphaComponent == 0){
                pixelBuffer[offset] = RGBA32(red: 100, green: 0, blue: 0, alpha: 255)
            }
            else if(pixelBuffer[offset] != RGBA32(red: 0, green: 0, blue: 0, alpha: 0)){
                pixelBuffer[offset] = RGBA32(red: 100, green: 0, blue: 0, alpha: 255)
            }
            else{
                pixelBuffer[offset] = RGBA32(red: 100, green: 0, blue: 0, alpha: 255)
            }
        }
    }

    let outputCGImage = context.makeImage()!
    let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)

    var filePath = saveImage(image: outputImage)
    
    if(filePath == ""){
        print("[Error] Image isn't saved")
        return nil
    }
    return filePath
}

// 이미지내 픽셀의 색상 변환 후 이미지 데이터로 전달
func processPixelsImageData(in image: UIImage, color: UIColor) -> Data? {
    guard let inputCGImage = image.cgImage else {
        print("[Error] unable to get cgImage")
        return nil
    }
    
    let colorSpace       = CGColorSpaceCreateDeviceRGB()
    let width            = inputCGImage.width
    let height           = inputCGImage.height
    let bytesPerPixel    = 4
    let bitsPerComponent = 8
    let bytesPerRow      = bytesPerPixel * width
    let bitmapInfo       = RGBA32.bitmapInfo
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    
    // ui color 값 받아오기
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
        print("[Error] unable to create context")
        return nil
    }
    context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

    guard let buffer = context.data else {
        print("[Error] unable to get context data")
        return nil
    }

    let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

    for row in 0 ..< Int(height) {
        for column in 0 ..< Int(width) {
            let offset = row * width + column
//            print(pixelBuffer[offset])
            if(pixelBuffer[offset] != RGBA32(red: 0, green: 0, blue: 0, alpha: 0)){
                pixelBuffer[offset] = RGBA32(red: UInt8(red * 255), green: UInt8(green * 255), blue: UInt8(blue * 255), alpha: 255)
//                pixelBuffer[offset] = RGBA32(red: 100, green: 100, blue: 0, alpha: 255)
            }
            else{
                pixelBuffer[offset] = RGBA32(red: UInt8(red * 255), green: UInt8(green * 255), blue: UInt8(blue * 255), alpha: 255)
//                pixelBuffer[offset] = RGBA32(red: 100, green: 100, blue: 0, alpha: 255)
            }
        }
    }

    let outputCGImage = context.makeImage()!
    let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)

    var filePath = saveImage(image: outputImage)
    
    var data = outputImage.pngData()
    
    if(filePath == ""){
        print("[Error] Image isn't saved")
        return nil
    }
    
    return data
}

//이미지를 로컬에 저장하고 경로 반환
func saveImage(image: UIImage) -> String {
    //?? image.jpegData(compressionQuality: 1)
    guard let data = image.pngData()  else {
        return ""
    }
    guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
        return ""
    }
    do {
        try data.write(to: directory.appendingPathComponent("brow.png")!)
        print("directory: \(directory)brow.png")
        return "\(directory)brow.png"
    } catch {
        print(error.localizedDescription)
        return ""
    }
}

struct RGBA32: Equatable {
    private var color: UInt32

    var redComponent: UInt8 {
        return UInt8((color >> 24) & 255)
    }

    var greenComponent: UInt8 {
        return UInt8((color >> 16) & 255)
    }

    var blueComponent: UInt8 {
        return UInt8((color >> 8) & 255)
    }

    var alphaComponent: UInt8 {
        return UInt8((color >> 0) & 255)
    }
    

    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let red   = UInt32(red)
        let green = UInt32(green)
        let blue  = UInt32(blue)
        let alpha = UInt32(alpha)
        color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
    }

    static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
    static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
    static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
    static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
    static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
    static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
    static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
    static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)

    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
        return lhs.color == rhs.color
    }
}
