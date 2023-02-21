//
//  RoundedButtonStyle.swift
//  
//
//  Created by Daniil Shmoylove on 26.01.2023.
//

import SwiftUI

//MARK: - RoundedButtonStyle

public struct RoundedButtonStyle: ButtonStyle {
    public init() { }
    
    public func makeBody(
        configuration: ButtonStyle.Configuration
    ) -> some View {
        RoundedButtonView(configuration: configuration)
    }
}

//MARK: - Typealias

public extension ButtonStyle where Self == RoundedButtonStyle {
    static var rounded: RoundedButtonStyle { RoundedButtonStyle() }
}

extension RoundedButtonStyle {
    
    //MARK: - RoundedButtonView
    
    private struct RoundedButtonView: View {
        let configuration: ButtonStyle.Configuration
        var body: some View {
            self.configuration.label
                .font(.system(size: 22, weight: .medium))
                .frame(width: 48, height: 48)
                .background(.thinMaterial)
                .clipShape(Circle())
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

#if DEBUG
struct RoundedButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: { }) {
            Image(systemName: "bolt.slash.fill")
        }
        .buttonStyle(.rounded)
    }
}
#endif
