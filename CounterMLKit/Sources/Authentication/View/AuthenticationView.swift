//
//  AuthenticationView.swift
//  
//
//  Created by Daniil Shmoylove on 08.04.2023.
//

import SwiftUI
import CoreUI

public struct AuthenticationView: View {
    public init() { }
    
    @State private var isGetStared: Bool = false
    
    public var body: some View {
        VStack(
            alignment: .center,
            spacing: 18
        ) {
            Image("app_art_2")
                .resizable()
                .scaledToFit()
                .bouncedAppearance(0.3)
                .pulsate(scale: (1.075, 0.925), duration: 2.75)
                .padding()
            
            Spacer()
            Text("Focus on\nyour nutrition.")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .multilineTextAlignment(.center)
                .bouncedAppearance(0.2)
                .padding(.horizontal)
            
            Text("Log in to have personalized access\non all devices")
                .foregroundColor(.secondary)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .bouncedAppearance(0.15)
            
            Button("Get started") { self.isGetStared.toggle() }
                .buttonStyle(.largeBorder())
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .padding()
                .padding(.bottom)
                .bouncedAppearance(0.1)
        }
        
        .sheet(isPresented: self.$isGetStared) {
            SignInView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

#if DEBUG
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
#endif
