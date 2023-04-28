//
//  SectionHeaderView.swift
//  
//
//  Created by Daniil Shmoylove on 11.04.2023.
//

import SwiftUI

public struct SectionHeaderView: View {
    public init(_ title: LocalizedStringKey) {
        self.title = title
    }
    
    private let title: LocalizedStringKey
    
    public var body: some View {
        Text(self.title)
            .textCase(nil)
            .foregroundColor(.primary)
            .font(.system(size: 22, weight: .semibold, design: .rounded))
            .offset(x: -16)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView("Dashboard")
    }
}
