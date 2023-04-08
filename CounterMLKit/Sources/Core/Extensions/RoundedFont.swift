//
//  RoundedFont.swift
//  
//
//  Created by Daniil Shmoylove on 08.04.2023.
//

#if canImport(UIKit)
import UIKit

public extension UIFont {
    class func roundedFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
}
#endif 
