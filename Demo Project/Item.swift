//
//  Item.swift
//  Demo Project
//
//  Created by John Durcan on 26/09/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
