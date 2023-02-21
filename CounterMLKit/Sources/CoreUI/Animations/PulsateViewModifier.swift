//
//  PulsateViewModifier.swift
//  
//
//  Created by Daniil Shmoylove on 24.01.2023.
//

import SwiftUI

//MARK: - View modifier 

public extension View {
    func pulsate(
        scale: (max: Double, min: Double) = (1.0, 0.8),
        duration: Double = 2.0,
        isActive: Bool = true
    ) -> some View {
        modifier(
            PulseModifier(
                scale: scale,
                duration: duration,
                isActive: isActive
            )
        )
    }
}

//MARK: - Pulse view modifier

/* Pulse animation view modifier */

struct PulseModifier: ViewModifier {
    private let scale: (max: Double, min: Double)
    private let duration: Double
    private let isActive: Bool
    
    init(
        scale: (Double, Double),
        duration: Double,
        isActive: Bool
    ) {
        self.scale = scale
        self.duration = duration
        self.isActive = isActive
    }
    
    @State private var isAnimate: Bool = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(self.isAnimate ? self.scale.max : self.scale.min)
            .onAppear {
                if self.isActive {
                    self.isAnimate.toggle()
                }
            }
            .animation(
                .easeInOut(duration: self.duration)
                .repeatForever(autoreverses: true),
                value: self.isAnimate
            )
    }
}
