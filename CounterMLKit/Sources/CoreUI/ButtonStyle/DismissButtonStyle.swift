//
//  DismissButtonStyle.swift
//  
//
//  Created by Daniil Shmoylove on 17.01.2023.
//

import SwiftUI

//MARK: - DismissButtonStyle

public struct DismissButtonStyle: ButtonStyle {
    public init() { }
    
    public func makeBody(
        configuration: ButtonStyle.Configuration
    ) -> some View {
        DismissButtonView(configuration: configuration)
    }
}

//MARK: - Typealias

public extension ButtonStyle where Self == DismissButtonStyle {
    static var dismiss: DismissButtonStyle { DismissButtonStyle() }
}

private extension DismissButtonStyle {
    
    //MARK: - DismissButtonView
    
    private struct DismissButtonView: View {
        let configuration: ButtonStyle.Configuration
        var body: some View {
            configuration.label
                .frame(width: 30, height: 30)
                .background(.secondary.opacity(0.3))
                .overlay {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .clipShape(Circle())
                .accessibilityLabel(Text("Close"))
        }
    }
}

#if DEBUG
struct DismissButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button { } label: {
            Text("Button")
        }
        .padding()
        .background(.red)
        .buttonStyle(DismissButtonStyle())
    }
}
#endif
