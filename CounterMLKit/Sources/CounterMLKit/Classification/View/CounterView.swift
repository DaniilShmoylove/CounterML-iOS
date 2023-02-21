//
//  CounterView.swift
//  
//
//  Created by Daniil Shmoylove on 20.01.2023.
//

import SwiftUI

public struct CounterView: View {
    @ObservedObject private var coordinator = Coordinator()
    
    public init() { }
    
    public var body: some View {
        NavigationStack(path: self.$coordinator.path) {
            List {
            }
            
            //MARK: - Toolbar
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(value: Route.addItem) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            
            //MARK: - Destinations
            
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .addItem:
#if canImport(UIKit)
                    CameraClassificationView()
#endif
                }
            }
        }
        
#if os(iOS)
        .tint(self.coordinator.path.last == .addItem ? .white : .accentColor)
        .statusBarHidden(self.coordinator.path.last == .addItem)
        .animation(.default, value: self.coordinator.path.last == .addItem)
#endif 
        
        //MARK: - Environments
        
        .environmentObject(self.coordinator)
    }
}

#if DEBUG
struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
#endif
