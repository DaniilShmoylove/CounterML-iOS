//
//  ClassificationViewModel.swift
//  
//
//  Created by Daniil Shmoylove on 23.01.2023.
//

import SwiftUI
import Services
import Resolver
import Foundation
import SharedModels
import AVFoundation

/// This is the class that interacts with the camera and the classification model.
/// The main task of the class is to provide the captured data to the CoreML model.

//MARK: - ClassificationViewModel

final class ClassificationViewModel: ObservableObject {
    
    //MARK: - Services
    
    @Injected private var mlService: MLService
    
    //MARK: - Classification data
    
    @Published var capturedClassification: DishModel? = nil
    
    // The largest number of predictions displays the user.
    
    private let predictionsToShow: Int = 3
    
    // The largest value of confidence percentage.
    
    private let confidencePercentageThreshold: Double = 55
    
    // Captured image data
    
    private var capturedImageData: Data? = nil {
        didSet {
            guard let capturedImageData else { return }
            self.classifyImage(capturedImageData)
        }
    }
}

extension ClassificationViewModel {
    
    // MARK: Image prediction methods
    /// Sends a photo to the Image Predictor to get a prediction of its content.
    /// - Parameter image: A photo.
    /// - Tag: ClassifyImage
    private func classifyImage(
        _ imageData: Data
    ) {
        do {
            try self.mlService.makePredictions(
                for: imageData,
                completionHandler: self.imagePredictionHandler
            )
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }
    
    /// The method the Image Predictor calls when its image classifier model generates a prediction.
    /// - Parameter predictions: An array of predictions.
    /// - Tag: imagePredictionHandler
    private func imagePredictionHandler(
        _ predictions: [Prediction]?
    ) {
        guard let predictions = predictions else {
            //TODO: - No image
            return
        }
        
        let formattedPredictions = self.formatPredictions(predictions)
        
        let predictionString = formattedPredictions
            .first?
            .name
            .replacingOccurrences(of: "_", with: " ")
        
        self.capturedClassification = .init(
            imageData: self.capturedImageData,
            name: predictionString ?? ""
        )
        
        //TODO: - Present logic
    }
    
    /// Converts a prediction's observations into human-readable strings.
    /// - Parameter observations: The classification observations from a Vision request.
    /// - Tag: formatPredictions
    private func formatPredictions(
        _ predictions: [Prediction]
    ) -> [(name: String, percentage: String)] {
        
        /// Vision sorts the classifications in descending confidence order.
        
        return predictions.prefix(self.predictionsToShow)
        
        /// Сheck if confidencePercentage is greater than confidencePercentageThreshold.
        
            .filter { Double($0.confidencePercentage) ?? .zero > self.confidencePercentageThreshold }
            .map { prediction in
                var name = prediction.classification
                
                /// For classifications with more than one name, keep the one before the first comma.
                
                if let firstComma = name.firstIndex(of: ",") {
                    name = String(name.prefix(upTo: firstComma))
                }
                
                return (prediction.classification.capitalized, prediction.confidencePercentage)
            }
    }
}

#if canImport(UIKit)

//MARK: - Camera

extension ClassificationViewModel {
    
    //MARK: - Camera result
    
    /// - Tag: CameraView
    func cameraResultHandler(
        _ result: Result<AVCapturePhoto, Error>
    ) {
        switch result {
            
            /// Photo capture completed successfully.
            
        case .success(let data):
            if let data = data.fileDataRepresentation() {
                
                /// The image data that is given to the model for classification.
                
                self.capturedImageData = data
            } else {
                fatalError("Error: no image data found.")
            }
            
            /// Photo capture error.
            
        case .failure(let failure):
            fatalError(failure.localizedDescription)
        }
    }
}
#endif
