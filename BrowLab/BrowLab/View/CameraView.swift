//
//  CameraView.swift
//  BrowLab
//
//  Created by YU WONGEUN on 2023/07/19.
//

// 화면에 session을 띄워주기 위함 추후 삭제 
import Foundation
import AVFoundation
import SwiftUI

struct CameraView: UIViewRepresentable {
    typealias UIViewType = PreviewView
    
    var captureSession: AVCaptureSession
    
    func makeUIView(context: Context) -> UIViewType {
        return UIViewType(captureSession: captureSession)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

class PreviewView: UIView {
    private var captureSession: AVCaptureSession
    
    init(captureSession: AVCaptureSession) {
        self.captureSession = captureSession
        super.init(frame: .zero)
    }
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let previewLayer = self.videoPreviewLayer
        previewLayer.frame = self.bounds
        

    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if nil != self.superview {
            self.videoPreviewLayer.session = self.captureSession
            self.videoPreviewLayer.videoGravity = .resizeAspectFill
        }
    }

}

