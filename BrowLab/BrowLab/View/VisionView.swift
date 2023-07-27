//
//  VisionView.swift
//  BrowLab
//
//  Created by YU WONGEUN on 2023/07/20.
//

import SwiftUI
import Vision

struct VisionView: View {
    @Binding var isFirst: Bool
    
    @EnvironmentObject var faceDetector: FaceDetector
    @EnvironmentObject var captureSession: CaptureSession
    @EnvironmentObject var personalizationModel: PersonalizationModel
    
    @StateObject var convertedPoints = ConvertedPoints()
    @State var ScanCheck: Bool = false
    @State var smoothedPoints = [CGPoint]() // 이전 위치들의 평균값을 저장하는 배열
    
    @State var allPoints = [CGPoint]()
    @State var toARSend = [CGPoint]()
    @State var scanPoints = [CGPoint]()
    let middlePoint = CGPoint(x: UIScreen.main.bounds.width / 2 , y: UIScreen.main.bounds.height / 2.5)
    
    var body: some View {
        ZStack {
            cameraView()
                .ignoresSafeArea(.all)// 보여주기 위함으로 후에 삭제
            ScanView1()
            //            ScanView()
            
            
        }.onChange(of: faceDetector.landmarks) { landmarks in // 여기 변화 감지 부분 이니까 컬러 하면 좋을듯
            guard let allPoints = landmarks?.allPoints?.normalizedPoints else { //lefteyebrow
                return
            }
            
            let indicesToExtract = [0, 1, 7, 8, 15, 18, 21, 24, 26, 34, 49, 50, 54, 55, 56, 59, 67, 75]
            
            
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
            
            //            print(convertedPoints)
            //            print("\(faceDetector.yaw) : \(faceDetector.pitch)")
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                
                if (faceDetector.yaw < 0.05 && faceDetector.pitch < 0.05) && (faceDetector.yaw > -0.05 && faceDetector.pitch > -0.05)
                    && (abs(convertedPoints[10].x - middlePoint.x) < 15) {
                    ScanCheck = true
                    captureSession.isFace = true
                    UserDefaults.standard.set(true, forKey: "isScanned")
                    DispatchQueue.main.asyncAfter(deadline: .now()+2){
                        isFirst = false
                        captureSession.stop()
                    }
                    self.scanPoints = convertedPoints
                    
                    personalizationModel.getPersonalizedValues(a: scanPoints[2], b: scanPoints[3], c: scanPoints[1], d: scanPoints[0], e: scanPoints[15], f: scanPoints[17], g: scanPoints[13], h: scanPoints[14], i: scanPoints[11], j: scanPoints[12], u: scanPoints[8], v: scanPoints[9], alpha: scanPoints[7], beta: scanPoints[6], gamma: scanPoints[5], delta: scanPoints[4])
                    print("VisionView | personalizedValues | headX: \(personalizationModel.headX), mountainZ: \(personalizationModel.mountainZ), eyebrowLengthArray: \(personalizationModel.eyebrowLengthArray)")
                    
                    UserDefaults.standard.set(personalizationModel.headX, forKey: "personalizedHeadX")
                    UserDefaults.standard.set(personalizationModel.mountainZ, forKey: "personalizedMountainZ")
                    UserDefaults.standard.set(personalizationModel.eyebrowLengthArray, forKey: "personalizedLen")
                    
                    
                }
                //            print("\(convertedPoints[10]) : \(middlePoint)")
                
            }
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
                            
                            Circle().fill(Color.blue).frame(width: 3, height: 3).position(imagePoint)
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
    
    @ViewBuilder
    func ScanView1() -> some View {
        
        if ScanCheck {
            
            
            ZStack {
                VStack {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.75)) // 배경 색상과 투명도 설정
                            .frame(width: 300, height: 110)
                        
                        
                        Text("스캔이 완료되었습니다!")
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow)
                        
                    }
                    .padding(.top, 80)
                    Spacer()
                }
                Image("frame_yellow")
                    .scaledToFit()
            }
            
        } else {
            ZStack {
                VStack {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.75)) // 배경 색상과 투명도 설정
                            .frame(width: 300, height: 110)
                        
                        
                        Text("정면을 바라보고\n얼굴을 그림에 맞춰주세요")
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                    }
                    .padding(.top, 80)
                    Spacer()
                }
                
                Circle().fill(Color.green).frame(width: 10, height: 10).position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2.5)
                
                Image("frame")
                    .scaledToFit()
            }
        }
    }
}


extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}
