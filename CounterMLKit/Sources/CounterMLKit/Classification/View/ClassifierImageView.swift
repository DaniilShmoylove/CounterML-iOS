//
//  ClassifierImageView.swift
//  
//
//  Created by Daniil Shmoylove on 20.02.2023.
//

#if os(iOS)
import SwiftUI

extension ClassifierView {
    struct ClassifierImageView: View {
        let imageData: Data
        
        init(imageData: Data) {
            self.imageData = imageData
        }
        
        @State private var isUseImage: Bool = true
        
        var body: some View {
            Section {
                Menu {
                    Toggle("Use photo", isOn: self.$isUseImage)
                } label: {
                    Image.createImage(self.imageData)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 196, height: 196)
                        .clipShape(Circle())
                        .frame(maxWidth: .infinity)
                        .rotatableAnimation()
                }
                .listRowBackground(Color.clear)
            }
        }
    }
}
#endif
