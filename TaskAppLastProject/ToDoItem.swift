//
//  ToDoItem.swift
//  TaskAppLastProject
//
//  Created by Saba Javakhishvili on 19.02.26.
//
import Foundation

struct ToDoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var dueDate: Date = Date() // თითოეულ თასქს ექნება თავისი თარიღი
}
