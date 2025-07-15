//
//  TodoItem.swift
//  UIinUI
//
//  Created by Nitin on 08/07/25.
//

import Foundation
import SwiftData


@Model
class TodoItem {
//struct TodoItem:Identifiable {
//    let id = UUID() //not neede as class and swift data model  manage ids itself
    var title : String
    var isCompleted: Bool = false
    var priority : TaskPriority
    init(title: String, isCompleted: Bool =  false, priority : TaskPriority = .medium) {
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
    }
}

enum TaskPriority: String,Codable,CaseIterable {
case low = "Low"
case medium = "Medium"
case high = "High"
}
