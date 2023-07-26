//
//  AVCaptureVM.swift
//  BrowLab
//
//  Created by doeun kim on 2023/07/22.
//

import AVFoundation
import Foundation
import UIKit

extension AVCapturePhoto {
    func hairSemanticSegmentationMatteImage() -> CIImage? {
        // 머리카락이 있는 부분을 가져옴
        print("photo: \(self)")
        if var matte = self.semanticSegmentationMatte(for: .hair) {
            if let orientation = self.metadata[String(kCGImagePropertyOrientation)] as? UInt32, let exifOrientation = CGImagePropertyOrientation(rawValue: orientation) {
                matte = matte.applyingExifOrientation(exifOrientation)
            }
            
            return CIImage(cvPixelBuffer: matte.mattingImage)
        }
        else{
            print("error - can't make segmentationMatte: \(self.semanticSegmentationMatte(for: .hair))")

        }
        return nil
    }
    
    func getPreviewPixelBufferImage() -> CIImage? {
        if let pixelBuffer = self.previewPixelBuffer {
            if let orientation = self.metadata[String(kCGImagePropertyOrientation)] as? UInt32, let exifOrientation = CGImagePropertyOrientation(rawValue: orientation) {
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer).oriented(forExifOrientation: Int32(exifOrientation.rawValue))
                return ciImage
            } else {
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                return ciImage
            }
        }
        return nil
    }
}
