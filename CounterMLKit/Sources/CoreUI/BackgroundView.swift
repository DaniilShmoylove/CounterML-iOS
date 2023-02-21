//
//  BackgroundView.swift
//  
//
//  Created by Daniil Shmoylove on 17.01.2023.
//

import SwiftUI

#if os(macOS)
struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.blendingMode = .behindWindow
        return effectView
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}
#endif

struct VisualEffectViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
#if os(macOS)
            .background(VisualEffectView().ignoresSafeArea())
#else
            .background(Color(uiColor: .secondarySystemBackground))
#endif
    }
}

public extension View {
    func sidebarBackground() -> some View {
        self.modifier(VisualEffectViewModifier())
    }
}
