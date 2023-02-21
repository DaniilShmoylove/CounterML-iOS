//
//  Coordinator.swift
//  
//
//  Created by Daniil Shmoylove on 21.01.2023.
//

import Foundation

//MARK: - Coordinator

final class Coordinator: ObservableObject {
    @Published var path = [Route]()
}

final class SidebarCoordinator: ObservableObject {
    @Published var path = [SidebarRoute]()
}
