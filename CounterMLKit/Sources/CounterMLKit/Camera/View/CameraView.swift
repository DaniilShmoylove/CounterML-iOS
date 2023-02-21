//
//  CameraView.swift
//  
//
//  Created by Daniil Shmoylove on 22.01.2023.
//

import SwiftUI
import AVFoundation
import Services
import Resolver
import Helpers
import Combine

#if canImport(UIKit)
struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    init(
        _ didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto, Error>) -> ()
    ) {
        self.didFinishProcessingPhoto = didFinishProcessingPhoto
    }
    
    private var viewModel = CameraViewModel()
    
    private let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
    
    func makeUIViewController(
        context: Context
    ) -> UIViewController {
        self.viewModel.start(
            delegate: context.coordinator
        ) { error in
            if let error {
                self.didFinishProcessingPhoto(.failure(error))
                return
            }
        }
        
        let viewController = CameraViewController(viewModel: self.viewModel)
        self.viewModel.setPreviewLayerFrame(for: viewController.view.bounds)
        return viewController
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(
            parent: self,
            didFinishProcessingPhoto: self.didFinishProcessingPhoto
        ) {
            self.viewModel.cameraState = .default
            self.viewModel.isOnFlashMode = false 
        }
    }
    
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let parent: CameraView
        private var didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
        private let completion: () -> ()
        
        init(
            parent: CameraView,
            didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto, Error>) -> (),
            completion: @escaping () -> ()
        ) {
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
            self.completion = completion
        }
        
        func photoOutput(
            _ output: AVCapturePhotoOutput,
            didFinishProcessingPhoto photo: AVCapturePhoto,
            error: Error?
        ) {
            self.completion()
            
            if let error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
            
            self.didFinishProcessingPhoto(.success(photo))
        }
    }
}
#endif

#if canImport(UIKit)
struct CameraSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("com.DaniilShmoylove.CounterML-iOS.currentCameraStyle") private var cameraStyle: CameraStyle = .default
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Showing prompt", isOn: .constant(true))
                } header: {
                    Text("Camera")
                } footer: {
                    Text("If this option is enabled, tooltips will be displayed while the camera is running.")
                }
                
                Section {
                    Picker(selection: self.$cameraStyle) {
                        ForEach(CameraStyle.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    } label: {
                        Text("Camera style")
                    }
                    Toggle("Auto-flash", isOn: .constant(true))
                }
                
                Section {
                    Label("Device \(UIDevice.current.name) \(UIDevice.current.systemVersion)", systemImage: "gearshape.2.fill")
                    Label("Bulid 0.0.1", systemImage: "square.stack.3d.up.fill")
                    Label("ML model 0.0.6", systemImage: "viewfinder")
                } header: {
                    Text("Versions")
                }
            }
            .navigationTitle("Settings")
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { self.dismiss() }
                        .fontWeight(.medium)
                }
            }
        }
        .tint(.accentColor)
    }
    
    enum CameraStyle: String, CaseIterable {
        case `default`, bordered
    }
}
#endif
