//
//  ResolverRegistering.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylove on 19.01.2023.
//

import Services
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        
        //MARK: - Register MLService
        
        /// Service responsible for processing data in the Food CoreML model.
        /// The main task of the class is to provide an API for processing data in the model.
        ///
        /// - Tag: Register MLService
        register { MLServiceImpl() }
            .implements(MLService.self)
        
        //MARK: - Register CameraService
        
        /// Service for processing data from the camera and its transfer.
        /// The main task of the class is to provide an API for taking photos.
        ///
        /// - Tag: Register CameraService
        register { CameraServiceImpl() }
            .implements(CameraService.self)
    }
}
