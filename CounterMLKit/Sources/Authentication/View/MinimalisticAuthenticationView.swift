//
//  MinimalisticAuthenticationView.swift
//  
//
//  Created by Daniil Shmoylove on 01.03.2023.
//

import SwiftUI
import CoreUI
import SharedModels

public struct MinimalisticAuthenticationView: View {
    public init() { }
    
    @State private var isGetStared: Bool = false
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: .zero) {
                Image("logo_art")
                    .resizable()
                    .frame(width: 96, height: 96)
                    .offset(x: -12)
                    .bouncedAppearance(0.3)
                
                Text("You're Welcome!\nFocus on\nyour nutrition.")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .bouncedAppearance(0.2)
                    .frame(height: 110)
                    .padding(.vertical, 10)
                
                Button("Get started") { self.isGetStared.toggle() }
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .bouncedAppearance(0.1)
            }
            .padding()
            
            .frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .leading
            )
            
            .sheet(isPresented: self.$isGetStared) {
                SignInView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#if DEBUG
struct MinimalisticAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        MinimalisticAuthenticationView()
    }
}
#endif
