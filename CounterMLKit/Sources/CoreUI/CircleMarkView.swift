//
//  CircleMarkView.swift
//  
//
//  Created by Daniil Shmoylove on 08.04.2023.
//

import SwiftUI

public struct CircleMarkView: View {
    public init(_ isOn: Bool) {
        self.isActive = isOn
    }
    
    private let isActive: Bool
    public var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
            .font(.system(size: 22, weight: .medium, design: .rounded))
            .opacity(self.isActive ? 1 : 0)
            .pulsate()
            .transition(.opacity)
            .animation(.easeInOut, value: self.isActive)
    }
}

#if DEBUG
struct CircleMarkView_Previews: PreviewProvider {
    static var previews: some View {
        CircleMarkView(true)
    }
}
#endif
