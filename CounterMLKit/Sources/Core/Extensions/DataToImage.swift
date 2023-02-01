//
//  DataToImage.swift
//  
//
//  Created by Daniil Shmoylove on 02.02.2023.
//

import SwiftUI

/// Adds functionality for `Image`
/// The function `createImage` converts a `Data` type to a `UIImage` type or `NSImage` type

public extension Image {
    static func createImage(_ value: Data) -> Image {
        
        /// Return as `NSImage` type
        
#if canImport(AppKit)
        let nsImage: NSImage = NSImage(data: value) ?? NSImage()
        return Image(nsImage: nsImage)
        
        /// Return as `UIImage` type
        
#elseif canImport(UIKit)
        let uiImage: UIImage = UIImage(data: value) ?? UIImage()
        return Image(uiImage: uiImage)
#else
        fatalError("Error: Unable to convert date type in UIImage or NSImage")
#endif
    }
}
