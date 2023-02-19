//
//  ScalableTransform.swift
//  
//
//  Created by Daniil Shmoylove on 13.02.2023.
//

#if canImport(UIKit)
import UIKit

/* Scale animations for UIButton */

public extension UIButton {
    
    //MARK: - Scalable
    
    /// Scalable animation for `UIButton`
    /// - parameter duration: animation duration
    /// - Tag: Scalable
    func scalable() {
        self.addTarget(
            self,
            action: #selector(self.scaleIn),
            for: [
                .touchDown,
                .touchDragEnter
            ]
        )
        
        self.addTarget(
            self,
            action: #selector(self.scaleOut),
            for: [
                .touchDragExit,
                .touchCancel,
                .touchUpInside,
                .touchUpOutside
            ]
        )
    }
    
    //MARK: - ScaleIn
    
    /// Simply zooming in of a view: set view scale to 0.85 and zoom.
    /// - Tag: ZoomIn
    @objc private func scaleIn(sender: UIButton) {
        animate(
            sender,
            transform: CGAffineTransform
                .identity
                .scaledBy(
                    x: 0.85,
                    y: 0.85
                )
        )
    }
    
    //MARK: - ScaleOut
    
    /// Simply zooming out of a view: set view scale to Identity.
    /// - Tag: ZoomOut
    @objc private func scaleOut(sender: UIButton) {
        animate(
            sender,
            transform: .identity
        )
    }
    
    //MARK: - Animate
    
    /// - Tag: Animate
    private func animate(
        _ button: UIButton,
        transform: CGAffineTransform
    ) {
        UIView.animate(
            withDuration: 0.2,
            delay: .zero,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 6,
            options: [.curveEaseInOut],
            animations: {
                button.transform = transform
            },
            completion: nil
        )
    }
}
#endif
