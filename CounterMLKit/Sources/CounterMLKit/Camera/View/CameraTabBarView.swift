//
//  CameraTabBarView.swift
//  
//
//  Created by Daniil Shmoylove on 19.02.2023.
//

#if canImport(UIKit)
import UIKit
import CoreUI

final internal class CameraTabBarView: UIView {
    
    //MARK: - Shutter button
    
    /// Simple circular camera shutter button with scalable animation
    /// - Tag: ShutterButton
    internal lazy var shutterButton: UIButton = {
        let button = UIButton()
        button.scalable()
        button.backgroundColor = .white
        button.clipsToCircle(frame: 72)
        return button
    }()
    
    //MARK: - Flash button
    
    /// Simple circular flash button with scalable animation
    /// - Tag: FlashButton
    internal lazy var flashButton: UIButton = {
        let button = UIButton()
        let height = 50.0
        button.frame = CGRect(x: .zero, y: .zero, width: height, height: height)
        button.setImage(UIImage(systemName: "flashlight.off.fill")!, for: .normal)
        button.imageView?.tintColor = .gray
        button.addBlurEffect(.systemThinMaterialDark, clipsToCircle: true)
        button.setPreferredSymbolConfiguration(.cameraTabItem, forImageIn: .normal)
        button.scalable()
        return button
    }()
    
    //MARK: - Image picker
    
    /// Simple circular image picker with scalable animation
    /// - Tag: ImagePicker
    internal lazy var imagePicker: UIButton = {
        let button = UIButton()
        let height = 50.0
        button.frame = CGRect(x: .zero, y: .zero, width: height, height: height)
        button.setImage(UIImage(systemName: "photo.fill")!, for: .normal)
        button.addBlurEffect(.systemThinMaterialDark, clipsToCircle: true)
        button.setPreferredSymbolConfiguration(.cameraTabItem, forImageIn: .normal)
        return button
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup view
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [
            self.flashButton,
            self.shutterButton,
            self.imagePicker
        ])
        
        self.addSubview(stackView)
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.flashButton.translatesAutoresizingMaskIntoConstraints = false
        self.shutterButton.translatesAutoresizingMaskIntoConstraints = false
        self.imagePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.flashButton.widthAnchor.constraint(equalToConstant: 50),
            self.flashButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.shutterButton.widthAnchor.constraint(equalToConstant: 72),
            self.shutterButton.heightAnchor.constraint(equalToConstant: 72),
            
            self.imagePicker.widthAnchor.constraint(equalToConstant: 50),
            self.imagePicker.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

//MARK: - CameraTabItem symbol configuration 

fileprivate extension UIImage.SymbolConfiguration {
    static var cameraTabItem: UIImage.SymbolConfiguration {
        UIImage.SymbolConfiguration(
            font: .systemFont(
                ofSize: 22,
                weight: .medium
            )
        )
    }
}
#endif
