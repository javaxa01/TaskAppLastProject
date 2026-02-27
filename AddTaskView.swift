import SwiftUI

struct AddTaskView: View {
    @Binding var tasks: [ToDoItem]
    @Environment(\.dismiss) var dismiss
    @State private var taskTitle: String = ""
    
    var body: some View {
        ZStack {
            backgroundGradient
            VStack {
                Text("New Task").font(.title.bold()).foregroundColor(.white).padding()
                
                TextField("What needs to be done?", text: $taskTitle)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding()
                
                Button("Save Task") {
                    if !taskTitle.isEmpty {
                        let newTask = ToDoItem(title: taskTitle, isCompleted: false, dueDate: Date())
                        tasks.append(newTask)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                
                Spacer()
            }
        }
    }
}
