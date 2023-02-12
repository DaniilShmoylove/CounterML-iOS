//
//  PhotosPickerHandler.swift
//
//
//  Created by Daniil Shmoylove on 19.01.2023.
//

import SwiftUI
import PhotosUI
import CoreTransferable

///This is a class for selecting photos to view and selecting a photo from user photo library.

//MARK: - PhotosPickerHandler

@MainActor
final public class PhotosPickerHandler: ObservableObject {
    public init() { }
    
    //MARK: - Current Image state
    
    @Published public var imageState: ImageState = .empty
    
    //MARK: - Image selection
    
    @Published public var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = self.loadTransferable(from: imageSelection)
                self.imageState = .loading(progress)
            } else {
                self.imageState = .empty
            }
        }
    }
}

extension PhotosPickerHandler {
    
    //MARK: - ImageState
    
    /// - Tag: ImageState
    public enum ImageState {
        case empty
        case loading(Progress)
        case success(Data)
        case failure(Error)
    }
    
    //MARK: - Transfer Image
    
    /// A transfer representation for types that participate in Swift’s protocols for encoding and decoding.
    /// - Warning: image is returned as `Data` type
    /// - Tag: TransferImage
    private struct TransferImage: Transferable {
        public let imageData: Data
        
        public static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                return TransferImage(imageData: data)
            }
        }
    }
    
    // MARK: - Load transferable
    
    /// Attempts to load an instance of the type you specify from the item provider, with a completion handler.
    /// - Parameters:
    ///   - request: A PhotoUI request.
    /// This method is called automatically when `imageSelection` is set to a new value.
    /// - Tag: LoadTransferable
    private func loadTransferable(
        from imageSelection: PhotosPickerItem
    ) -> Progress {
        return imageSelection.loadTransferable(type: TransferImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.imageData)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}
