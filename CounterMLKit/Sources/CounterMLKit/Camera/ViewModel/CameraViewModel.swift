//
//  CameraViewModel.swift
//  
//
//  Created by Daniil Shmoylove on 19.02.2023.
//

#if os(iOS)
import Resolver
import Services
import AVFoundation

//MARK: - CameraViewModel

/// This ViewModel provides an API for interacting with the application's camera.
/// - Tag: CameraViewModel
final class CameraViewModel: ObservableObject {
    init() { }
    
    //MARK: - Camera service
    
    /// Service responsible for processing smartphone camera data.
    /// - Tag: CameraService
    @Injected private var cameraService: CameraService
    
    //MARK: - Flash control
    
    /// Turn on the camera flashlight
    /// - Tag: IsOnFlashMode
    @Published var isOnFlashMode: Bool = false {
        didSet {
            self.cameraService.toggleTorch(self.isOnFlashMode)
        }
    }
    
    //MARK: - Camera state
    
    /// Stores the current state of the camera
    /// Needed to determine the behavior of the camera during photo capture
    /// - Tag: CameraState
    @Published var cameraState: CameraState = .default
}

extension CameraViewModel {
    
    //MARK: - Camera state
    
    /// State of camera
    /// - Tag: CameraState
    enum CameraState {
        case `default`, loading
    }
}

//MARK: - Camera control

extension CameraViewModel {
    
    /// Start camera
    
    func start(
        delegate: AVCapturePhotoCaptureDelegate,
        completion: @escaping (Error?) -> ()
    ) {
        self.cameraService.start(
            delegate: delegate,
            completion: completion
        )
    }
    
    /// Capture photo with camera state change
    
    func capturePhoto() {
        self.cameraService.capturePhoto()
        self.cameraState = .loading
    }
    
    /// Stop camera method
    
    func stop() {
        self.cameraService.stop()
    }
    
    /// Set frame for `previewLayer`
    
    func setPreviewLayerFrame(for bounds: CGRect) {
        self.cameraService.previewLayer.frame = bounds
    }
    
    /// A Core Animation layer that displays video from a camera device.
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        self.cameraService.previewLayer
    }
}
#endif
