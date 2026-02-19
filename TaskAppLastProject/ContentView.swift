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
        ToDoItem(title: "Explore SwiftUI Features", isCompleted: false),
        ToDoItem(title: "Design Modern UI", isCompleted: true)
    ]
    
    var body: some View {
        NavigationStack {
            MainTaskView(tasks: $tasks)
        }
    }
}

// საერთო ფონი, რომელიც ყველა ფაილში გამოგვადგება
var backgroundGradient: some View {
    LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.05, green: 0.05, blue: 0.15), Color(red: 0.1, green: 0.15, blue: 0.4)]),
        startPoint: .top,
        endPoint: .bottom
    ).ignoresSafeArea()
}
