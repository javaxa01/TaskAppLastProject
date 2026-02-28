

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var tasks: [ToDoItem] = [
        ToDoItem(title: "FinalProject", isCompleted: false, dueDate: Date()),
        ToDoItem(title: "Do WorkOut", isCompleted: true, dueDate: Date())
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
            Color(red: 0.05, green: 0.08, blue: 0.12), 
            Color.white
        ]),
        startPoint: .top,
        endPoint: .bottom
    ).ignoresSafeArea()
}
