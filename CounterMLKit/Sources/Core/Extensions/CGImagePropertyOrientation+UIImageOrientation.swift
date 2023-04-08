//
//  CGImagePropertyOrientation+Extension.swift
//  
//
//  Created by Daniil Shmoylove on 18.01.2023.
//

#if canImport(UIKit)
import UIKit
import ImageIO

public extension CGImagePropertyOrientation {
    
    /**
     Converts a `ImageOrientation` to a corresponding
     `CGImagePropertyOrientation`. The cases for each
     orientation are represented by different raw values.
     
     - Tag: ConvertOrientation
     */
    
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: fatalError()
        }
    }
}
#endif
