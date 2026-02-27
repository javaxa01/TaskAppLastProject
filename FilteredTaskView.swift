import SwiftUI

struct FilteredTaskView: View {
    @Binding var tasks: [ToDoItem]
    var filterCompleted: Bool
    
    @State private var newTaskTitle: String = ""
    @State private var selectedDate: Date = Date()
    @State private var isShowingAddSheet = false

    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack {
                if !filterCompleted {
                    quickAddSection
                }

                ScrollView {
                    VStack(spacing: 12) {
                        let filteredIndices = tasks.indices.filter { tasks[$0].isCompleted == filterCompleted }
                        
                        if filteredIndices.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: filterCompleted ? "checkmark.circle" : "calendar.badge.plus")
                                    .font(.system(size: 50))
                                Text("No tasks found").font(.headline)
                            }
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.top, 100)
                        } else {
                            ForEach(filteredIndices, id: \.self) { index in
                                taskRowExtended(index: index)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(filterCompleted ? "Completed" : "Pending Tasks")
        .toolbar {
            if !filterCompleted {
                Button(action: { isShowingAddSheet.toggle() }) {
                    Image(systemName: "plus.circle.fill").foregroundColor(.cyan)
                }
            }
        }
        // პატარა ფანჯარა თარიღის ასარჩევად
        .sheet(isPresented: $isShowingAddSheet) {
            quickAddSheet
        }
    }

    // ზედა სწრაფი დამატების სექცია
    var quickAddSection: some View {
        VStack(spacing: 10) {
            HStack {
                TextField("Add new pending task...", text: $newTaskTitle)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(12)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                Button(action: addNewTask) {
                    Image(systemName: "plus.square.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.cyan)
                }
            }
            
            DatePicker("Due Date", selection: $selectedDate, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.compact)
                .background(Color.white.opacity(0.8).cornerRadius(8))
        }
        .padding()
        .background(Color.black.opacity(0.2))
    }

    func taskRowExtended(index: Int) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(tasks[index].title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(tasks[index].dueDate, style: .date)
                        .font(.caption)
                }
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: { tasks.remove(at: index) }) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red.opacity(0.7))
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
    }

    private func addNewTask() {
        if !newTaskTitle.isEmpty {
            let newItem = ToDoItem(title: newTaskTitle, isCompleted: false, dueDate: selectedDate)
            tasks.append(newItem)
            newTaskTitle = ""
        }
    }
    
    var quickAddSheet: some View {
        VStack(spacing: 20) {
            Text("New Pending Task").font(.headline).padding()
            TextField("What needs to be done?", text: $newTaskTitle).textFieldStyle(.roundedBorder).padding()
            DatePicker("Pick a deadline", selection: $selectedDate, displayedComponents: .date).datePickerStyle(.graphical).padding()
            Button("Save Task") {
                addNewTask()
                isShowingAddSheet = false
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .presentationDetents([.medium])
    }
}
