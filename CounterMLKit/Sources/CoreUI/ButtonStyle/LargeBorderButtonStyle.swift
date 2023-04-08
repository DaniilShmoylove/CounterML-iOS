//
//  LargeBorderButtonStyle.swift
//  
//
//  Created by Daniil Shmoylove on 02.03.2023.
//

import SwiftUI

//MARK: - LargeBorderButtonStyle

public struct LargeBorderButtonStyle: ButtonStyle {
    public init(_ tint: Color) {
        self.tint = tint
    }
    
    let tint: Color
    
    public func makeBody(
        configuration: ButtonStyle.Configuration
    ) -> some View {
        LargeBorderButtonView(configuration: configuration, color: tint)
    }
}

//MARK: - Typealias

public extension ButtonStyle where Self == LargeBorderButtonStyle {
    static func largeBorder(
        _ tint: Color = .accentColor
    ) -> LargeBorderButtonStyle { LargeBorderButtonStyle(tint) }
}

private extension LargeBorderButtonStyle {
    
    //MARK: - CapturePhotoButtonView
    
    private struct LargeBorderButtonView: View {
        let configuration: ButtonStyle.Configuration
        let color: Color
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(color)
                .animation(.default, value: self.isEnabled)
                .cornerRadius(16)
            
                .scaleEffect(self.configuration.isPressed ? 0.85 : 1.0)
                .animation(
                    .spring(
                        response: 0.25,
                        dampingFraction: 0.35,
                        blendDuration: 0.75
                    ),
                    value: self.configuration.isPressed
                )
        }
    }
}
