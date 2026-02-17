//
//  Task.swift
//  TaskAppLastProject
//
//  Created by Saba Javakhishvili on 18.02.26.
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
    }
}

