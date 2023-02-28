//
//  ClassificationModelPriorityColor.swift
//  
//
//  Created by Daniil Shmoylove on 28.02.2023.
//

import SwiftUI

public extension ClassificationModel {
    
    //MARK: - Priority color
    
    /// Returns the set color for the priority `CFP` value.
    ///
    /// - Tag: PriorityColor
    var priorityColor: Color {
        let cfp = [self.carbs, self.fat, self.protein]
        
        switch cfp.max() {
        case self.carbs: return .green
        case self.fat: return .orange
        case self.protein: return .blue
        default: return .secondary
        }
    }
}
