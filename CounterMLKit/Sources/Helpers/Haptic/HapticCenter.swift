//
//  HapticCenter.swift
//  
//
//  Created by Daniil Shmoylove on 19.01.2023.
//

#if canImport(UIKit)
import UIKit

final public class HapticCenter {
    private init() { }
    
    //MARK: - Impact style
    
    public class func impact(
        style: UIImpactFeedbackGenerator.FeedbackStyle
    ) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    //MARK: - Notification style
    
    public class func notification(
        type: UINotificationFeedbackGenerator.FeedbackType
    ) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    //MARK: - Selection style
    
    public class func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
#endif 
