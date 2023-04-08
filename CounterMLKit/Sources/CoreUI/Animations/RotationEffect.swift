//
//  RotationEffect.swift
//  
//
//  Created by Daniil Shmoylove on 23.01.2023.
//

import SwiftUI

//MARK: - ViewModifier

public extension View {
    func rotatableAnimation() -> some View {
        self.modifier(RotationEffectModifier())
    }
}

//MARK: - Rotation effect modifier

/* Rotation effect animation view modifier */

struct RotationEffectModifier: ViewModifier {
    
    @State private var isRotationEffect: Bool = false
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(self.isRotationEffect ? 12: -12),
                axis: (
                    x: self.isRotationEffect ? 90 : -45,
                    y: self.isRotationEffect ? -45 : -90, z: 0
                )
            )
            .animation(
                .easeInOut(duration: 6).repeatForever(),
                value: self.isRotationEffect
            )
            .onAppear() {
                self.isRotationEffect = true 
            }
    }
}
