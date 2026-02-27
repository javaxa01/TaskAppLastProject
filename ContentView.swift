//
//  ContentView.swift
//  TaskAppLastProject
//
//  Created by Saba Javakhishvili on 19.02.26.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var tasks: [ToDoItem] = [
        ToDoItem(title: "Explore SwiftUI Features", isCompleted: false, dueDate: Date()),
        ToDoItem(title: "Design Modern UI", isCompleted: true, dueDate:     Date())
    ]
    
    var body: some View {
        NavigationStack {
            MainTaskView(tasks: $tasks)
        }
    }
}

var backgroundGradient: some View {
    LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.01, green: 0.1, blue: 0.05),
            Color(red: 0.05, green: 0.2, blue: 0.1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    ).ignoresSafeArea()
}
