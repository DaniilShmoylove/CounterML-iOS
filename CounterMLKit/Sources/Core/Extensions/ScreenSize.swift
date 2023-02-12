//
//  ScreenSize.swift
//  
//
//  Created by Daniil Shmoylove on 17.01.2023.
//

import SwiftUI

public extension View {
    
    //MARK: - Get screen size func
    
    /* Extension func */
    /* Func return screen size for both OS */
    
    @inlinable
    func getRect() -> CGRect {
        
        /* MacOS */
        
#if canImport(AppKit)
        return NSScreen.main!.visibleFrame
        
        /* iOS */
        
#elseif canImport(UIKit)
        return UIScreen.main.bounds
        
        /* AppKit or UIKit cannot be imported */
#else
        return .init()
#endif
    }
}
