//
//  DebugView.swift
//  CounterML-iOS
//
//  Created by Daniil Shmoylov on 03.07.2024.
//

import SwiftUI

public struct DebugView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: DebugViewModel = .init()
    
    public init() { }
    
    @StateObject private var coordinator = DebugCoordinator()
    
    public var body: some View {
        NavigationStack(path: self.$coordinator.path) {
            List {
                self.userSection
            }
            .listStyle(.sidebar)
        }
        
        .navigationDestination(for: DebugRoute.self) { route in
            switch route {
            case .userStats: EmptyView()
            }
        }
        
        .environmentObject(self.coordinator)
        
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        
#if os(macOS)
        .frame(width: 250, height: 400)
#endif
    }
}

private extension DebugView {
    private var userSection: some View {
        Section {
            Button(role: .destructive) {
                viewModel.signOut()
            } label: {
                Text("Sign Out")
            }
            
        } header: {
            Text("User")
        }
    }
}

#Preview {
    DebugView()
}
