//
//  dist.swift
//  BrowLab
//
//  Created by YU WONGEUN on 2023/07/24.
//

import Foundation

func dist(_ a: CGPoint, _ b: CGPoint) -> Double {
    sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y))
}


