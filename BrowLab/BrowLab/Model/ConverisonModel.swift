//
//  ConverisonModel.swift
//  BrowLab
//
//  Created by Wonil Lee on 2023/07/25.
//

import Foundation

class ConversionModel: ObservableObject {
    // headX = (distance between two heads of eyebrows) / 2
    @Published var headX: Float = 0.0
    // mountainZ = -(height of mountains of eyebrows from the center of face anchor)
    @Published var mountainZ: Float = 0.0
    // eyebrowLength = length of eyebrow
    @Published var eyebrowLengthDictionary: [String: Float] = [:]
    
    func getThreeValues(a: CGPoint, b: CGPoint, c: CGPoint, d: CGPoint, e: CGPoint, f: CGPoint, g: CGPoint, h: CGPoint, i: CGPoint, j: CGPoint, u: CGPoint, v: CGPoint, alpha: CGPoint, beta: CGPoint, gamma: CGPoint, delta: CGPoint) {
        /*
         a: outer end of left eye
         b: inner end of left eye
         c: inner end of right eye
         d: outer end of right eye
         e: left end of face
         f: right end of face
         g: up-left of nose
         h: up-right of nose
         i: down-left of nose
         j: down-right of nose
         u: left end of mouth
         v: right end of mouth
         alpha: up-middle of left eyebrow
         beta: down-middle of left eyebrow
         gamma: up-middle of right eyebrow
         delta: down-middle or right eyebrow
         */
        
        func getMiddle(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
            CGPoint(x: (a.x + b.x) * 0.5, y: (a.y + b.y) * 0.5)
        }
        
        func dist(_ a: CGPoint, _ b: CGPoint) -> Double {
            sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) + (a.y - b.y))
        }
        
        /*
         l: center of left eye
         r: center or right eye
         q: middle of l and r
         p1: up-middle of nose(similar to the center of face anchor)
         p2: down-middle of nose
         m: center of mouth
         */
        
        let l = getMiddle(a, b)
        let r = getMiddle(c, d)
        let q = getMiddle(l, r)
        let p1 = getMiddle(g, h)
        let p2 = getMiddle(i, j)
        let m = getMiddle(u, v)
        
        // base is a value that is proportional to the size(1D) of face
        let base = dist(l, p1) + dist(r, p1) + dist(m, p1)
        
        // proportional constants for each values (a.k.a. k1, k2, k3 each)
        // need to get k1, k2, k3 through real world experiment
        let proportionalConstantOfHeadX = 0.1
        let proportionalConstantOfMountainZ = 0.1
        let proportionalConstantOfEyebrowLength = 0.1
        
        headX = Float(proportionalConstantOfHeadX * dist(i, j) / base)
        
        mountainZ = Float(-proportionalConstantOfMountainZ * (dist(p1, q) + (dist(a, b) + dist(c, d)) * 0.5) / base)
        
        eyebrowLengthDictionary = [String: Float]()
        
        let tempFactor1 = proportionalConstantOfEyebrowLength * (max(dist(a, d) - dist(i, j), 0.000_000_001) * 0.5) * (dist(p2, q) + (dist(a, b) + dist(c, d)) * 0.5)
        
        for name in EyebrowAssetData.eyebrowNameArray {
            let tempFactor2 = dist(p2, q) + max(dist(a, d) - dist(i, j), 0.000_000_001) * 0.5 * (EyebrowAssetData.eyebrowRatioDictionary[name] ?? EyebrowAssetData.basicEyebrowRatio)
            
            eyebrowLengthDictionary[name] = Float(tempFactor1 / tempFactor2 / base)
        }
    }

}
