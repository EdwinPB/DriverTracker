//
//  Item.swift
//  DriverTracker
//
//  Created by Edwin Polo on 31/07/26.
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
