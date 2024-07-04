//
//  DebugCoordinator.swift
//
//
//  Created by Daniil Shmoylov on 03.07.2024.
//

import Foundation

class DebugCoordinator: ObservableObject {
    @Published var path = [DebugRoute]()
}

enum DebugRoute: Hashable {
    case userStats
}
