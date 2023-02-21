//
//  CameraViewController.swift
//  
//
//  Created by Daniil Shmoylove on 19.02.2023.
//

#if canImport(UIKit)
import UIKit
import Combine

final class CameraViewController: UIViewController {
    
    //MARK: - ViewModel
    
    private let viewModel: CameraViewModel
    
    // MARK: - Init
    
    init(viewModel: CameraViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Binding
    
    /// - Tag: Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    /// That func creates bindings for `ViewModel` variables.
    /// - Tag: ShutterButton
    private func bindingViewModel() {
        
        /// Camera state observer
        
        self.viewModel.$cameraState
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .default:
                    self.cameraTabBar.isUserInteractionEnabled = true
                case .loading:
                    self.cameraTabBar.isUserInteractionEnabled = false
                }
            }
            .store(in: &self.cancellables)
        
        /// IsOnFlashMode observer
        
        self.viewModel.$isOnFlashMode
            .sink { [weak self] isOn in
                guard let self = self else { return }
                
                if isOn {
                    self.cameraTabBar.flashButton.setImage(
                        UIImage(systemName: "flashlight.on.fill"),
                        for: .normal
                    )
                    self.cameraTabBar.flashButton.imageView?.tintColor = .white
                } else {
                    self.cameraTabBar.flashButton.setImage(
                        UIImage(systemName: "flashlight.off.fill"),
                        for: .normal
                    )
                    self.cameraTabBar.flashButton.imageView?.tintColor = .lightGray
                }
            }
            .store(in: &self.cancellables)
    }
    
    //MARK: - CameraTabBar
    
    /// Camera tab bar view
    /// - Tag: CameraTabBar
    private let cameraTabBar = CameraTabBarView()
    
    //MARK: - CameraTabBar controls
    
    /// - Tag: CapturePhoto
    @objc private func capturePhoto() {
        self.viewModel.capturePhoto()
    }
    
    /// - Tag: ToggleTorch
    @objc private func toggleTorch() {
        self.viewModel.isOnFlashMode.toggle()
    }
    
    //MARK: - Configure ViewController
    
    private func configure() {
        self.view.backgroundColor = .black
        self.view.layer.addSublayer(self.viewModel.previewLayer)
        self.view.addSubview(self.cameraTabBar)
        
        self.cameraTabBar.shutterButton.addTarget(
            self,
            action: #selector(self.capturePhoto),
            for: .touchUpInside
        )
        
        self.cameraTabBar.flashButton.addTarget(
            self,
            action: #selector(self.toggleTorch),
            for: .touchUpInside
        )
        
        self.cameraTabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.cameraTabBar
                .centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            
            self.cameraTabBar
                .widthAnchor
                .constraint(equalTo: self.view.layoutMarginsGuide.widthAnchor, constant: -48),
            
            self.cameraTabBar
                .heightAnchor
                .constraint(equalToConstant: 72),
            
            self.cameraTabBar
                .bottomAnchor
                .constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -24)
        ])
    }
}

//MARK: - Lifecycle

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bindingViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.stop()
    }
}
#endif
