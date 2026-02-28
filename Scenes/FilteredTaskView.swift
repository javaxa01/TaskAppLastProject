import SwiftUI

struct FilteredTaskView: View {
    @Binding var tasks: [ToDoItem]
    var filterCompleted: Bool
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack {
                List {
                    let filteredIndices = tasks.indices.filter { tasks[$0].isCompleted == filterCompleted }
                    
                    if filteredIndices.isEmpty {
                        noTasksView
                    } else {
                        ForEach(filteredIndices, id: \.self) { index in
                            taskRowExtended(index: index)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: { indexSet in
                            deleteTask(at: indexSet, from: filteredIndices)
                        })
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(filterCompleted ? "Completed" : "Pending Tasks")
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
            
            if tasks[index].isCompleted {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
        .padding(.vertical, 4)
    }

    // წაშლის ლოგიკა
    private func deleteTask(at offsets: IndexSet, from filteredIndices: [Int]) {
        withAnimation {
            for index in offsets {
                let actualIndex = filteredIndices[index]
                tasks.remove(at: actualIndex)
            }
        }
    }

    var noTasksView: some View {
        VStack(spacing: 15) {
            Image(systemName: "tray")
                .font(.system(size: 50))
            Text("No tasks here")
        }
        .foregroundColor(.white.opacity(0.4))
        .frame(maxWidth: .infinity, minHeight: 400)
        .listRowBackground(Color.clear)
    }
}
