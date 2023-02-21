//
//  CameraService.swift
//  
//
//  Created by Daniil Shmoylove on 22.01.2023.
//

import AVFoundation

/// Service responsible for processing smartphone camera data.
/// The protocol provides an API for configuring the camera and taking photos.

//MARK: - CameraService protocol

/// - Tag: CameraService
public protocol CameraService {
    
    // Start method
    
    func start(
        delegate: AVCapturePhotoCaptureDelegate,
        completion: @escaping (Error?) -> ()
    )
    
    // Stop method
    
    func stop()
    
    // Initiates a photo capture using the specified settings.
    
    func capturePhoto()
    
    // Methods for monitoring progress and receiving results from a photo capture output.
    
    var delegate: AVCapturePhotoCaptureDelegate? { get }
    
    // A Core Animation layer that displays video from a camera device.
    
    var previewLayer: AVCaptureVideoPreviewLayer { get }
    
    // Turn on the camera flashlight
    
    func toggleTorch(_ set: Bool)
}

//MARK: - CameraServiceImpl

/// - Tag: CameraServiceImpl
final public class CameraServiceImpl {
    public init() { }
    
    //MARK: - Session
    
    /// - Tag: session
    private var session: AVCaptureSession?
    
    // Delegate contains methods for monitoring progress and receiving results from a photo capture output.
    
    public var delegate: AVCapturePhotoCaptureDelegate?
    
    // Photo output
    
    private let output = AVCapturePhotoOutput()
    
    // Video preview layer
    
    public let previewLayer = AVCaptureVideoPreviewLayer()
    
    //MARK: - CapturePhotoSettings
    
    /// - Tag: capturePhotoSettings
    private var capturePhotoSettings: AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        return settings
    }
}

extension CameraServiceImpl: CameraService {
    
    //MARK: - Start
    
    public func start(
        delegate: AVCapturePhotoCaptureDelegate,
        completion: @escaping (Error?) -> ()
    ) {
        self.delegate = delegate
        
        // Check permission
        
        print("Camera been started \(delegate) was: \(self.delegate as Any)")
        
        self.checkPermission { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - Stop session
    
    /// - Tag: stop
    public func stop() {
        if let session, session.isRunning {
            DispatchQueue.main.async {
                session.stopRunning()
            }
        }
    }
    
    //MARK: - Check permission
    
    private func checkPermission(
        completion: @escaping (Error?) -> ()
    ) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.setupCamera(completion: completion)
                }
            }
        case .restricted: break
        case .denied: break
        case .authorized:
            self.setupCamera(completion: completion)
        @unknown default:
            fatalError("Failed to authorization camera")
        }
    }
    
    //MARK: - Setup camera
    
    private func setupCamera(
        completion: @escaping (Error?) -> ()
    ) {
        let session = AVCaptureSession()
        
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(self.output) {
                    session.addOutput(self.output)
                }
                
                self.previewLayer.videoGravity = .resizeAspectFill
                self.previewLayer.session = session
                
                //MARK: - Session start running
                
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                    self.session = session
                }
            } catch {
                completion(error)
            }
        }
    }
    
    //MARK: - Capture photo
    
    /// Initiates a photo capture using the specified settings.
    /// - Tag: capturePhoto
    public func capturePhoto() {
        print("Capture")
        guard let delegate else { return }
        self.output.capturePhoto(
            with: self.capturePhotoSettings,
            delegate: delegate
        )
    }
    
    //MARK: - Toggle torch
    
    /// This method use the `lockForConfiguration()` and `unlockForConfiguration()` methods of the `AVCaptureDevice` class in order to make sure only one app can control the torch at a time.
    /// - Tag: toggleTorch
    public func toggleTorch(_ set: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if set {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}
