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
        let songArtwork: NSImage = NSImage(data: value) ?? NSImage()
        return Image(nsImage: songArtwork)
        
        /// Return as `UIImage` type
        
#elseif canImport(UIKit)
        let songArtwork: UIImage = UIImage(data: value) ?? UIImage()
        return Image(uiImage: songArtwork)
#else
        fatalError("Error: Unable to convert date type in UIImage or NSImage")
#endif
    }
}
