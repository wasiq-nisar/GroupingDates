//
//  FruitModel.swift
//  GroupBySwift
//
//  Created by Muhammad Wasiq  on 17/01/2024.
//

import Foundation
import UIKit

struct GroupedFruits {
    var date: String
    var fruits: [FruitModel]
}

struct FruitModel {
    var name: String
    var color: String
    var createdAtDate: Date
    var dateString: String
    var id: UUID?
    
    init(name: String, color: String, createdAtDate: Date, dateString: String = "", id: UUID? = nil) {
        self.name = name
        self.color = color
        self.id = id
        self.createdAtDate = createdAtDate
        self.dateString = dateString
    }
}
