//
//  CaptureSessionVM.swift
//  BrowLab
//
//  Created by YU WONGEUN on 2023/07/19.
//

import Foundation
import AVFoundation
import UIKit

class CaptureSession: NSObject, ObservableObject {
    @Published var sampleBuffer: CMSampleBuffer?
    @Published var isFace = false
    @Published var takePhoto = false
    
    var captureSession: AVCaptureSession?
    let photoOutput = AVCapturePhotoOutput()
    private lazy var photoSettings = AVCapturePhotoSettings()
    let previewLayer = CALayer()
    
    func setup() {
        var allowedAccess = false
        let blocker = DispatchGroup()
//        blocker.enter()
//        AVCaptureDevice.requestAccess(for: .video) { flag in
//            allowedAccess = flag
//            blocker.leave()
//        }
//        blocker.wait()
//        if !allowedAccess { return }
//        
//        if !allowedAccess {
//            print("Camera access is not allowed.")
//            return
//        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        
        let videoDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front)
        guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
            print("Unable to detect camera.")
            return
        }
        session.addInput(videoDeviceInput)
        
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "SampleBuffer"))
        if (session.canAddOutput(videoOutput)) {
            session.addOutput(videoOutput)
        }
        
        if (session.canAddOutput(photoOutput)) {
            session.addOutput(photoOutput)
            photoOutput.maxPhotoQualityPrioritization = .quality
        }
        
        photoOutput.enabledSemanticSegmentationMatteTypes = photoOutput.availableSemanticSegmentationMatteTypes
        photoOutput.isDepthDataDeliveryEnabled = true
        photoOutput.isPortraitEffectsMatteDeliveryEnabled = true
        photoOutput.isHighResolutionCaptureEnabled = true
        
        if  photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        }
        
        photoSettings.isHighResolutionPhotoEnabled = true


        if let previewPhotoPixelFormatType = self.photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
        }
        
        photoSettings.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliveryEnabled
        photoSettings.isPortraitEffectsMatteDeliveryEnabled = photoOutput.isPortraitEffectsMatteDeliveryEnabled
        if photoSettings.isDepthDataDeliveryEnabled {
            if !photoOutput.availableSemanticSegmentationMatteTypes.isEmpty {
                photoSettings.enabledSemanticSegmentationMatteTypes = photoOutput.availableSemanticSegmentationMatteTypes
                print("photo setting: \(photoSettings.enabledSemanticSegmentationMatteTypes)")
            }
        }
        
        session.commitConfiguration()
        self.captureSession = session
    }
    
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .off
        photoOutput.capturePhoto(with: self.photoSettings, delegate: self)
    }
    
    func start() {
        guard let captureSession = self.captureSession else {
            return
        }
        
        if (!captureSession.isRunning) {
            captureSession.startRunning()
        }
    }
    
    func stop() {
        guard let captureSession = self.captureSession else {
            return
        }
        if (captureSession.isRunning) {
            captureSession.stopRunning()
        }
    }
}

extension CaptureSession: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Error while generating image from photo capture data.");
            return
        }
        
        let originUIImage = UIImage(data: imageData)
        
        self.originImage = UIImage(data: photo.fileDataRepresentation()!)
//        let originCIImage = CIImage(image: originUIImage!)
        let originCIImage = photo.getPreviewPixelBufferImage()
        
        
        DispatchQueue.main.async {
            guard let segmentedCIImage = photo.hairSemanticSegmentationMatteImage() else {
                print("Error segmented photo")
                return
            }
            
            let uiImage = UIImage(ciImage: photo.hairSemanticSegmentationMatteImage()!)
            self.hairImage = photo.hairSemanticSegmentationMatteImage()
            
            guard let base = originCIImage else{
                return
            }
            var matte = segmentedCIImage
            
            let scale = CGAffineTransform(scaleX: base.extent.size.width / matte.extent.size.width, y: base.extent.size.height / segmentedCIImage.extent.size.height)
            matte = matte.transformed( by: scale)
            
            let context = CIContext(options: nil)
            let segmentedCGImage = context.createCGImage(matte, from: matte.extent)
            let originCGImage = context.createCGImage(originCIImage!, from: originCIImage!.extent)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            
            let originColorSpace = CGColorSpaceCreateDeviceRGB()
            let originBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            
            let segmentedWidth = segmentedCGImage!.width
            let segmentedHeight = segmentedCGImage!.height
            let segmentedBytesPerRow = segmentedCGImage!.bytesPerRow
            
            let originWidth = originCGImage!.width
            let originHeight = originCGImage!.height
            let originBytesPerRow = originCGImage!.bytesPerRow
            
            guard let segmentContext = CGContext(data: nil, width: segmentedWidth, height: segmentedHeight, bitsPerComponent: 8, bytesPerRow: segmentedBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
                fatalError("Could not create CGContext")
            }
            
            guard let originContext = CGContext(data: nil, width: originWidth, height: originHeight, bitsPerComponent: 8, bytesPerRow: originBytesPerRow, space: originColorSpace, bitmapInfo: originBitmapInfo.rawValue) else {
                fatalError("Could not create CGContext")
            }

            segmentContext.draw(segmentedCGImage!, in: CGRect(x: 0, y: 0, width: segmentedWidth, height: segmentedHeight))
            
            originContext.draw(originCGImage!, in: CGRect(x: 0, y: 0, width: originWidth, height: originHeight))
            
            guard let pixelData = segmentContext.data else {
                fatalError("Could not get pixel data from context")
            }
            
            let pixel_cnt = segmentedWidth*segmentedHeight
            
            guard let originPixelData = originContext.data else {
                fatalError("Could not get pixel data from context")
            }
            
            var origin_pixel_cnt = 0
            
//            var pixelArray: [[UIColor]] = []
            
            var totalRed = 0.0
            var totalGreen = 0.0
            var totalBlue = 0.0
            var totalAlpha = 0.0
            
            print("SegmentedWidth: \(segmentedWidth)")
            print("SegmentedHeight: \(segmentedHeight)")
            print("OriginWidth: \(originWidth)")
            print("OriginHeight: \(originHeight)")
            
            print("origin: \(originBytesPerRow)  segme: \(segmentedBytesPerRow)")

            
            // 색상을 받아올 좌표 확인하기
            for y in 0..<segmentedHeight {
                for x in 0..<segmentedWidth{
                    if(x % 2 == 0){
                        continue
                    }
                    let pixelOffset = (y * segmentedBytesPerRow) + (x * 4)
                    let red = CGFloat(pixelData.load(fromByteOffset: pixelOffset, as: UInt8.self)) / 255.0
                    let green = CGFloat(pixelData.load(fromByteOffset: pixelOffset + 1, as: UInt8.self)) / 255.0
                    let blue = CGFloat(pixelData.load(fromByteOffset: pixelOffset + 2, as: UInt8.self)) / 255.0
                    let alpha = CGFloat(pixelData.load(fromByteOffset: pixelOffset + 3, as: UInt8.self)) / 255.0

//                    print("red: \(red) Green: \(green) Blue: \(blue)  Alpha:  \(alpha)")
                    if red == 1.0 && green == 1.0 && blue == 1.0 {
                        let origin_pixelOffset = (Int(y * (originHeight / segmentedHeight)) * originBytesPerRow) + (Int(x * (originWidth / segmentedWidth)) * 4)
                        var resize_x = x * (originWidth / segmentedWidth)
                        var resize_y = y * (originHeight / segmentedHeight)
                        
//                        print("x: \(x)  y: \(y)  resize_x: \(resize_x)  resize_y: \(resize_y)")
//                        let origin_pixelOffset = (y  * originBytesPerRow) + (Int(x ) * 4)
                        let origin_red = CGFloat(originPixelData.load(fromByteOffset: origin_pixelOffset, as: UInt8.self)) / 255.0
                        let origin_green = CGFloat(originPixelData.load(fromByteOffset: origin_pixelOffset + 1, as: UInt8.self)) / 255.0
                        let origin_blue = CGFloat(originPixelData.load(fromByteOffset: origin_pixelOffset + 2, as: UInt8.self)) / 255.0
                        let origin_alpha = CGFloat(originPixelData.load(fromByteOffset: origin_pixelOffset + 3, as: UInt8.self)) / 255.0
//                        print("red: \(origin_red) Green: \(origin_green) Blue: \(origin_blue)  Alpha:  \(origin_alpha)")
                        
                        if origin_red == 0 && origin_blue == 0 && origin_green == 0 {
                            continue
                        }
                        
                        origin_pixel_cnt+=1
                        totalRed += origin_red
                        totalGreen += origin_green
                        totalBlue += origin_blue
                        totalAlpha += origin_alpha
                    }
//                    let color = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
//                    row.append(color)
                }
                
//                pixelArray.append(row)
            }
            
            self.color = UIColor(
                red: CGFloat(totalRed) / CGFloat(origin_pixel_cnt),
                green: CGFloat(totalGreen) / CGFloat(origin_pixel_cnt),
                blue: CGFloat(totalBlue) / CGFloat(origin_pixel_cnt),
                alpha: CGFloat(totalAlpha) / CGFloat(origin_pixel_cnt)
            )
            
            print("color: \(self.color)")
        }
    }
}

extension CaptureSession: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if self.isFace && !takePhoto {
            capturePhoto()
            self.takePhoto = true
        }
        
        DispatchQueue.main.async {
            self.sampleBuffer = sampleBuffer
        }
    }
}


