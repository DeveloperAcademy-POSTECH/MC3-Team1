//
//  VisionView.swift
//  BrowLab
//
//  Created by YU WONGEUN on 2023/07/20.
//

import SwiftUI
import Vision

struct VisionView: View {
    
    @EnvironmentObject var faceDetector: FaceDetector
    @EnvironmentObject var captureSession: CaptureSession
    @StateObject var convertedPoints = ConvertedPoints()
    
    @State var smoothedPoints = [CGPoint]() // 이전 위치들의 평균값을 저장하는 배열
    
    
    @State var allPoints = [CGPoint]()
    
    @State var toARSend = [CGPoint]()
    
    var body: some View {
        ZStack {
            cameraView() // 보여주기 위함으로 후에 삭제
            VStack {
                qualityView()
                Spacer()
            }
            VStack {
                Spacer()
                positionView()
            }
        }.onChange(of: faceDetector.landmarks) { landmarks in // 여기 변화 감지 부분 이니까 컬러 하면 좋을듯
            guard let allPoints = landmarks?.allPoints?.normalizedPoints else { //lefteyebrow
                return
            }
            
            let indicesToExtract = [0, 1, 7, 8, 15, 18, 21, 24, 50, 54, 55, 56, 59, 75]
            
            self.toARSend = indicesToExtract.compactMap { index in
                guard index < allPoints.count else {
                    return nil
                }
                return allPoints[index]
            }
            
            self.allPoints = allPoints
            let screenSize = UIScreen.main.bounds.size
            
            let convertedPoints = toARSend.map { CGPoint(x: $0.x * screenSize.width, y: $0.y * screenSize.height)}
            self.convertedPoints.points = convertedPoints
            
            print(convertedPoints)
            
            
            
            //            // 새로운 landmarks를 받았을 때 이전 위치들의 평균값 계산 smoothing
            //                       let currentPoints = toARSend.map { CGPoint(x: $0.x , y: $0.y ) }
            //
            //                       if smoothedPoints.isEmpty {
            //                           smoothedPoints = currentPoints
            //                       } else {
            //                           let smoothingFactor: CGFloat = 0.1 // 부드럽게 만들기 위한 smoothing factor 값
            //
            //                           for i in 0..<currentPoints.count {
            //                               let smoothedX = (currentPoints[i].x * smoothingFactor) + (smoothedPoints[i].x * (1 - smoothingFactor))
            //                               let smoothedY = (currentPoints[i].y * smoothingFactor) + (smoothedPoints[i].y * (1 - smoothingFactor))
            //                               smoothedPoints[i] = CGPoint(x: smoothedX, y: smoothedY)
            //                           }
            //                       }
            //
            
        }
    }
    
    @ViewBuilder
    func cameraView() -> some View {
        if let captureSession = captureSession.captureSession {
            CameraView(captureSession: captureSession)
                .overlay(
                    GeometryReader { geometry in
                        ForEach(toARSend, id: \.self) { point in
                            let vectoredPoint = vector2(Float(point.x),Float(point.y))
                            
                            let vnImagePoint = VNImagePointForFaceLandmarkPoint(
                                vectoredPoint,
                                faceDetector.boundingBox,
                                Int(geometry.size.width),
                                Int(geometry.size.height))
                            
                            let imagePoint = CGPoint(x: vnImagePoint.x, y: vnImagePoint.y)
                            
                            Circle().fill(Color.green).frame(width: 3, height: 3).position(imagePoint)
                        }
                    })
        } else {
            Text("Preparing Capture Session ...")
        }
    }
    
    @ViewBuilder
    func qualityView() -> some View {
        HStack {
            Text(String(format: "Face Capture Quality: %.2f", faceDetector.faceCaptureQuality))
            Spacer()
        }.padding().background(Color.gray)
    }
    
    @ViewBuilder
    func positionView() -> some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
            ],
            alignment: .leading,
            spacing: 0,
            pinnedViews: [],
            content: {
                Text(String(format: "Pitch: %.2f", faceDetector.pitch))
                Text(String(format: "Roll: %.2f", faceDetector.roll))
                Text(String(format: "Yaw: %.2f", faceDetector.yaw))
            }).padding().background(Color.gray)
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}
