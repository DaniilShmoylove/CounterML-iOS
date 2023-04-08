//
//  BouncedAppearanceModifier.swift
//  
//
//  Created by Daniil Shmoylove on 02.03.2023.
//

import SwiftUI

//MARK: - ViewModifier

public extension View {
    @inlinable
    @inline(__always)
    func bouncedAppearance(_ delay: TimeInterval = .zero) -> some View {
        self.modifier(BouncedAppearanceModifier(delay))
    }
}

//MARK: - BouncedAppearanceModifier

public struct BouncedAppearanceModifier: ViewModifier {
    public init(_ delay: TimeInterval) {
        self.delay = delay
    }
    
    private let delay: TimeInterval
    
    @State private var isAppearance: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .offset(y: self.isAppearance ? .zero : 72)
            .opacity(self.isAppearance ? 1.0 : .zero)
            .scaleEffect(self.isAppearance ? 1.0 : 0.9)
        
            .onAppear {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + self.delay
                ) {
                    withAnimation(
                        .spring(
                            response: 0.3,
                            dampingFraction: 0.45,
                            blendDuration: 0.85
                        )
                    ) {
                        self.isAppearance = true
                    }
                }
            }
    }
}
