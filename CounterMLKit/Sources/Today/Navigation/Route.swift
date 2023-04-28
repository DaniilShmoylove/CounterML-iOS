//
//  Route.swift
//  
//
//  Created by Daniil Shmoylove on 21.01.2023.
//

import Foundation
import SharedModels

//MARK: - Navigation

enum Route: Hashable {
    case mealNote(_ item: MealModel)
    case classificationNote(_ item: ClassificationModel)
    case addItem
    case classificationCamera
}

////MARK: - Equatable
//
//extension Route: Equatable {
//    static func == (lhs: Route, rhs: Route) -> Bool {
//        switch (lhs, rhs) {
//        case (.mealNote(let item1), .mealNote(let item2)):
//            return item1 == item2
//        case (.classificationNote(let item1), .classificationNote(let item2)):
//            return item1 == item2
//        case (.classificationCamera, .classificationCamera):
//            return true
//        default:
//            return false
//        }
//    }
//}


enum SidebarRoute: Int, Hashable {
    case home, stats, settings, notification, account
}
