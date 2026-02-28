import SwiftUI

struct AddTaskView: View {
    @Binding var tasks: [ToDoItem]
    @Environment(\.dismiss) var dismiss
    
    @State private var taskTitle: String = ""
    @State private var dueDate: Date = Date()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Create New Task")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? 20 : 40)
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("WHAT ARE YOU PLANNING?")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                    .kerning(1)
                                
                                TextField("Enter task title...", text: $taskTitle)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.1)))
                                    .foregroundColor(.white)
                                    .focused($isTextFieldFocused)
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("DUE DATE")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                    .kerning(1)
                                
                                DatePicker("", selection: $dueDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .colorScheme(.dark)
                                    .accentColor(.cyan)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.05)))
                            }
                        }
                        .padding()
                    }
                    
                    Button(action: addNewTask) {
                        Text("Save Task")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(
                                LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(15)
                            .shadow(color: .cyan.opacity(0.3), radius: 10, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 10 : 30)
                    .disabled(taskTitle.isEmpty)
                    .opacity(taskTitle.isEmpty ? 0.5 : 1.0)
                }
            }
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
        .navigationBarHidden(true)
    }
    
    private func addNewTask() {
        let newTask = ToDoItem(title: taskTitle, isCompleted: false, dueDate: dueDate)
        withAnimation {
            tasks.append(newTask)
            dismiss()
        }
    }
}
