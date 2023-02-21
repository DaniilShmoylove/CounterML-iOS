//
//  BlurEffect.swift
//  
//
//  Created by Daniil Shmoylove on 18.02.2023.
//

#if canImport(UIKit)
import UIKit

public extension UIButton {
    func addBlurEffect(
        _ style: UIBlurEffect.Style,
        clipsToCircle: Bool = false
    ) {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false 
        
        if clipsToCircle {
            blur.layer.cornerRadius = 0.5 * self.bounds.size.width
            blur.clipsToBounds = true
        }
        
        if let imageView = self.imageView {
            self.insertSubview(blur, belowSubview: imageView)
        }
    }
}
#endif


#if canImport(UIKit)
import UIKit

public extension UIButton {
    func clipsToCircle(frame: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: frame, height: frame)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.clipsToBounds = true 
    }
}

#endif
