//
//  File.swift
//  
//
//  Created by Daniil Shmoylove on 23.01.2023.
//

import SwiftUI

//MARK: - CapturePhotoButtonStyle

public struct CapturePhotoButtonStyle: ButtonStyle {
    public init() { }
    
    public func makeBody(
        configuration: ButtonStyle.Configuration
    ) -> some View {
        CapturePhotoButtonView(configuration: configuration)
    }
}

//MARK: - Typealias

public extension ButtonStyle where Self == CapturePhotoButtonStyle {
    static var capture: CapturePhotoButtonStyle { CapturePhotoButtonStyle() }
}

private extension CapturePhotoButtonStyle {
    
    //MARK: - CapturePhotoButtonView
    
    private struct CapturePhotoButtonView: View {
        let configuration: ButtonStyle.Configuration
        var body: some View {
            configuration.label
                .scaleEffect(self.configuration.isPressed ? 0.85 : 1.0)
                .animation(
                    .spring(
                        response: 0.25,
                        dampingFraction: 0.35,
                        blendDuration: 0.75
                    ),
                    value: self.configuration.isPressed
                )
                .accessibilityLabel(Text("Capture photo"))
        }
    }
}
