//
//  MLService.swift
//  
//
//  Created by Daniil Shmoylove on 18.01.2023.
//

import CoreML
import Vision
import SwiftUI
import Core
import Resources

/// The app in this sample identifies the most prominent object in an
/// image by using `FoodClassifier`, an open source image classifier model that
/// recognizes around ~200 different categories.

/// Service responsible for processing data in the Food CoreML model.
/// The main task of the class is to provide an API for processing data in the model

//MARK: - MLService protocol

public protocol MLService {
    
    // Create image classifier
    
    @discardableResult
    static func createImageClassifier() -> VNCoreMLModel
    
    // Generates an image classification prediction for a photo.
    
    func makePredictions(
        for imageData: Data,
        completionHandler: @escaping ImagePredictionHandler
    ) throws
}

//MARK: - Image prediction handler

// The function signature the caller must provide as a completion handler.

public typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void

// Stores a classification name and confidence for an image classifier's prediction.

//MARK: - Prediction

/// - Tag: Prediction
public struct Prediction {
    
    // The name of the object or scene the image classifier recognizes in an image.
    
    public let classification: String
    
    // The image classifier's confidence as a percentage string.
    // The prediction string doesn't include the % symbol in the string.
    
    public let confidencePercentage: String
}

//MARK: - MLServiceImpl

final public class MLServiceImpl: ObservableObject {
    public init() { }
    
    // A common image classifier instance that all Image Predictor instances use to generate predictions.
    
    private static let imageClassifier = createImageClassifier()
    
    // A dictionary of prediction handler functions, each keyed by its Vision request.
    
    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()
}

extension MLServiceImpl: MLService {
    
    //MARK: - Create image classifier
    
    /// - Tag: FoodClassifier
    @discardableResult
    public static func createImageClassifier() -> VNCoreMLModel {
        
        // Use a default model configuration with modelDisplayName.
        
        let defaultConfig = MLModelConfiguration()
        defaultConfig.modelDisplayName = "Food"
        
        // Create an instance of the image classifier's wrapper class.
        
        let imageClassifierWrapper = try?  FoodClassifier(configuration: defaultConfig)
        
        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }
        
        // Get the underlying model instance.
        
        let imageClassifierModel = imageClassifier.model
        
        // Create a Vision instance using the image classifier's model instance.
        
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }
        
        return imageClassifierVisionModel
    }
    
    //MARK: - Create image classification request
    
    // Generates a new request instance that uses the Image Predictor's image classifier model.
    
    private func createImageClassificationRequest() -> VNImageBasedRequest {
        
        // Create an image classification request with an image classifier model.
        
        let imageClassificationRequest = VNCoreMLRequest(
            model: MLServiceImpl.imageClassifier,
            completionHandler: visionRequestHandler
        )
        
        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }
    
    //MARK: - Make predictions (macOS)
    
    // Generates an image classification prediction for a photo.
    
    /// - Parameter photo: An image, typically of an object or a scene.
    /// - Tag: makePredictions for macOS
    public func makePredictions(
        for imageData: Data,
        completionHandler: @escaping ImagePredictionHandler
    ) throws {
#if canImport(AppKit)
        guard
            let nsImage = NSImage(data: imageData),
            let photoImage = nsImage.cgImage(
                forProposedRect: nil,
                context: nil,
                hints: nil
            ) else {
            fatalError("Photo doesn't have underlying CGImage.")
        }
        
        //FIXME: - Fix macos image orientation
        
        let orientation: CGImagePropertyOrientation = .up
#elseif canImport(UIKit)
        guard
            let uiImage = UIImage(data: imageData),
            let photoImage = uiImage.cgImage
        else {
            fatalError("Photo doesn't have underlying CGImage.")
        }
        
        let orientation = CGImagePropertyOrientation(uiImage.imageOrientation)
#else
        fatalError("AppKit or UIKit cannot be imported")
#endif
        
        let imageClassificationRequest = self.createImageClassificationRequest()
        self.predictionHandlers[imageClassificationRequest] = completionHandler
        
        let handler = VNImageRequestHandler(
            cgImage: photoImage,
            orientation: orientation
        )
        
        let requests: [VNRequest] = [imageClassificationRequest]
        
        // Start the image classification request.
        
        try handler.perform(requests)
    }
    
    //MARK: - Vision request handler
    
    /// The completion handler method that Vision calls when it completes a request.
    /// - Parameters:
    ///   - request: A Vision request.
    ///   - error: An error if the request produced an error; otherwise `nil`.
    ///
    ///   The method checks for errors and validates the request's results.
    /// - Tag: visionRequestHandler
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        
        // Remove the caller's handler from the dictionary and keep a reference to it.
        
        guard let predictionHandler = self.predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }
        
        // Start with a `nil` value in case there's a problem.
        
        var predictions: [Prediction]? = nil
        
        // Call the client's completion handler after the method returns.
        
        defer {
            
            // Send the predictions back to the client.
            
            predictionHandler(predictions)
        }
        
        // Check for an error first.
        
        if let error = error {
            print("Vision image classification error...\n\n\(error.localizedDescription)")
            return
        }
        
        // Check that the results aren't `nil`.
        
        if request.results == nil {
            print("Vision request had no results.")
            return
        }
        
        // Cast the request's results as an `VNClassificationObservation` array.
        
        guard let observations = request.results as? [VNClassificationObservation] else {
            
            // Image classifiers, like MobileNet, only produce classification observations.
            // However, other Core ML model types can produce other observations.
            // For example, a style transfer model produces `VNPixelBufferObservation` instances.
            
            print("VNRequest produced the wrong result type: \(type(of: request.results)).")
            return
        }
        
        // Create a prediction array from the observations.
        
        predictions = observations.map { observation in
            
            // Convert each observation into an `ImagePredictor.Prediction` instance.
            
            Prediction(
                classification: observation.identifier,
                confidencePercentage: observation.confidencePercentageString
            )
        }
    }
}
