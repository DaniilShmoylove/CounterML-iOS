//
//  LargeBorderButtonStyle.swift
//  
//
//  Created by Daniil Shmoylove on 02.03.2023.
//

import SwiftUI

//MARK: - LargeBorderButtonStyle

public struct LargeBorderButtonStyle: ButtonStyle {
    public init() { }
    
    public func makeBody(
        configuration: ButtonStyle.Configuration
    ) -> some View {
        LargeBorderButtonView(configuration: configuration)
    }
}

//MARK: - Typealias

public extension ButtonStyle where Self == LargeBorderButtonStyle {
    static var largeBorder: LargeBorderButtonStyle { LargeBorderButtonStyle() }
}

private extension LargeBorderButtonStyle {
    
    //MARK: - CapturePhotoButtonView
    
    private struct LargeBorderButtonView: View {
        let configuration: ButtonStyle.Configuration
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(self.isEnabled ? Color.accentColor : .secondary.opacity(0.5))
                .animation(.default, value: self.isEnabled)
                .clipShape(Capsule())
            
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
