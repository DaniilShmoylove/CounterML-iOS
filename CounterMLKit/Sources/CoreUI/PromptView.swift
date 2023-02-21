//
//  PromptView.swift
//  
//
//  Created by Daniil Shmoylove on 19.02.2023.
//

import SwiftUI

//MARK: - Camera prompt

/// This view displays screen tips for the user.
/// PromptView automatically `localizes` text
/// - Tag: PromptView
public struct PromptView: View {
    
    /// Description value
    /// - Tag: Description
    private let description: String
    
    /// Animation delay
    /// Default value is `4.5`
    /// - Tag: Delay
    private let delay: CGFloat
    
    /// Need to `show or hide` view during appearance
    /// - Tag: IsShowingPrompt
    @State private var isShowingPrompt: Bool = true
    
    //MARK: - Init
    
    public init(
        _ description: String,
        delay: CGFloat = 4.5
    ) {
        self.description = description
        self.delay = delay
    }
    
    public var body: some View {
        Text(LocalizedStringKey(self.description))
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(.thinMaterial)
            .clipShape(Capsule())
        
        /// Animations
        
            .opacity(self.isShowingPrompt ? 1 : 0)
            .offset(y: self.isShowingPrompt ? 0 : -128)
            .onAppear {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + TimeInterval(self.delay)
                ) {
                    withAnimation(.easeOut) {
                        self.isShowingPrompt = false
                    }
                }
            }
        
        /// User skip
        
            .onTapGesture {
                withAnimation(.easeOut) {
                    self.isShowingPrompt = false
                }
            }
    }
}
