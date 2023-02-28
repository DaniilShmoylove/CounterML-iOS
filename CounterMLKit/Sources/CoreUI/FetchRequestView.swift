//
//  FetchRequestView.swift
//  
//
//  Created by Daniil Shmoylove on 26.02.2023.
//

import SwiftUI
import CoreData

//MARK: - FetchRequestView

/// The generic view container that creates the `FetchRequest`.
///
/// > Instantiate a custom FetchRequest providing the required arguments.
/// > After that, the request will be automatically performed by the View when
/// > its render is required and the result will be passed to the custom content
/// > that is a @ViewBuilder provided in initializer itself.
///
/// - Parameters:
///    - T: A Core Data model object.
///    - Content: View that will be displayed.
///
/// - Tag: FetchRequest
public struct FetchRequestView<
    T: NSManagedObject,
    Content: View
>: View {
    
    //MARK: - Fetch request
    
    /// That will store our fetch request, so that we can loop over it inside the body.
    /// However, we don’t create the fetch request here, because we still don’t know what we’re searching for.
    /// Instead, we’re going to create custom initializer(s)
    /// that accepts filtering information to set the fetchRequest property.
    ///
    /// - Tag: FetchRequest
    @FetchRequest private var fetchRequest: FetchedResults<T>
    
    /// this is our content closure; we'll call this once the fetch results is available
    ///
    /// - Tag: Content
    private let content: (FetchedResults<T>) -> Content
    
    //MARK: - Body
    
    public var body: some View {
        self.content(fetchRequest)
    }
    
    //MARK: - Init with filtering information
    
    /// This is a generic initializer that allow to provide all filtering information
    
    public init(
        withPredicate predicate: NSPredicate,
        andSortDescriptor sortDescriptors: [NSSortDescriptor] = [],
        @ViewBuilder content: @escaping (FetchedResults<T>) -> Content
    ) {
        self._fetchRequest = FetchRequest<T>(
            sortDescriptors: sortDescriptors,
            predicate: predicate,
            animation: .default
        )
        
        self.content = content
    }
    
    //MARK: - Init with NSFetchRequest
    
    /// This initializer allows to provide a complete custom `NSFetchRequest`
    
    public init(
        withFetchRequest request:NSFetchRequest<T>,
        @ViewBuilder content: @escaping (FetchedResults<T>) -> Content
    ) {
        self._fetchRequest = FetchRequest<T>(
            fetchRequest: request,
            animation: .default
        )
        
        self.content = content
    }
}
