//
//  DismissibleViewModifier.swift
//  
//
//  Created by Daniil Shmoylove on 24.01.2023.
//

import SwiftUI

public extension View {
    func dismissible(
        dismiss action: @escaping () -> ()
    ) -> some View {
        self.modifier(
            DismissibleViewModifier(
                action: action
            )
        )
    }
}

struct DismissibleViewModifier: ViewModifier {
    let action: () -> ()
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        self.action()
                    }
                }
            }
    }
}
