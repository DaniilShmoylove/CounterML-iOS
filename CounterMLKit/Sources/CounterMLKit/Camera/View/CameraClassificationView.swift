//
//  CameraClassificationView.swift
//  
//
//  Created by Daniil Shmoylove on 01.02.2023.
//

#if os(iOS)
import SwiftUI
import CoreUI

struct CameraClassificationView: View {
    
    //MARK: - ViewModel 
    
    @StateObject private var viewModel = ClassificationViewModel()
    
    var body: some View {
        
        // MARK: - Camera view
        
        GeometryReader { geometry in
            CameraView { result in
                self.viewModel.cameraResultHandler(result)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
        }
        .ignoresSafeArea()
        
        //MARK: - Camera prompt
        
        .overlay(alignment: .top) {
            PromptView("Point the camera at the plate")
        }
        
        //MARK: - Add Classifier view
        
        .sheet(
            item: self.$viewModel.classification
        ) {
            ClassifierView(data: $0)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        
        // Hide tab bar
        
        .toolbar(.hidden, for: .tabBar)
    }
}
#endif
