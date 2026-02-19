import SwiftUI

@main
struct TaskApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// --- მოდელი ---
struct ToDoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}

struct ContentView: View {
    @State private var tasks: [ToDoItem] = [
        ToDoItem(title: "Explore SwiftUI Features", isCompleted: false),
        ToDoItem(title: "Design Modern UI", isCompleted: true),
        ToDoItem(title: "Setup Data Persistence", isCompleted: false)
    ]
    
    var body: some View {
        NavigationStack {
            MainTaskView(tasks: $tasks)
        }
    }
}

// --- გვერდი 1: მთავარი სია ---
struct MainTaskView: View {
    @Binding var tasks: [ToDoItem]
    
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(alignment: .leading) {
                headerSection
                
                // ფილტრის ღილაკები
                HStack(spacing: 30) {
                    Spacer()
                    filterButton(title: "All", icon: "list.bullet", color: .white, active: true)
                    
                    NavigationLink(destination: FilteredTaskView(tasks: $tasks, filterCompleted: true)) {
                        filterButton(title: "Done", icon: "checkmark.seal.fill", color: .green, active: false)
                    }
                    
                    NavigationLink(destination: FilteredTaskView(tasks: $tasks, filterCompleted: false)) {
                        filterButton(title: "Pending", icon: "clock.badge.exclamationmark", color: .orange, active: false)
                    }
                    Spacer()
                }
                .padding(.vertical)

                // სტატისტიკის ახალი ვიზუალი (Progress Card)
                statisticsCard
                
                // დავალებების სია
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach($tasks) { $task in
                            taskRow(task: $task)
                        }
                    }
                    .padding(.horizontal)
                }

                // დამატების ღილაკი
                HStack {
                    Spacer()
                    NavigationLink(destination: AddTaskView(tasks: $tasks)) {
                        plusButton
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
            }
        }
        .navigationBarHidden(true)
    }
    
    // --- კომპონენტები ---
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("MY DAILY TASKS")
                    .font(.system(size: 14, weight: .black))
                    .kerning(2)
                Spacer()
                // გასწორებული კალენდარი
                ZStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 28))
                    Text("\(Calendar.current.component(.day, from: Date()))")
                        .font(.system(size: 10, weight: .bold))
                        .offset(y: 3)
                }
            }
            .foregroundColor(.white.opacity(0.8))
            .padding(.horizontal)
            .padding(.top, 20)
            
            Text(currentDateString)
                .font(.system(size: 34, weight: .heavy))
                .foregroundColor(.white)
                .padding(.leading)
            
            TimelineView(.periodic(from: .now, by: 1.0)) { context in
                Text(context.date, style: .time)
                    .font(.system(size: 20, weight: .light))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.leading)
            }
        }
    }
    
    var statisticsCard: some View {
        let completedCount = tasks.filter { $0.isCompleted }.count
        let totalCount = tasks.count
        let progress = totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
        
        return HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Progress Status")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        statRow(title: "Completed", count: completedCount, color: .green)
                        statRow(title: "Incomplete", count: totalCount - completedCount, color: .orange)
                    }
                    
                    Spacer()
                    
                    // პროცენტულობის წრე
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 8)
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                LinearGradient(colors: [.cyan, .blue], startPoint: .top, endPoint: .bottom),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 60, height: 60)
                }
            }
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.12)))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.1), lineWidth: 1))
            .padding(.horizontal)
        }
    }
    
    func taskRow(task: Binding<ToDoItem>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.wrappedValue.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(task.wrappedValue.isCompleted ? .gray : .primary)
                    .strikethrough(task.wrappedValue.isCompleted)
            }
            Spacer()
            Button(action: { withAnimation { task.wrappedValue.isCompleted.toggle() } }) {
                Image(systemName: task.wrappedValue.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.wrappedValue.isCompleted ? .green : .gray)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    func filterButton(title: String, icon: String, color: Color, active: Bool) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(title).font(.caption2).fontWeight(.bold)
        }
        .foregroundColor(active ? .white : .gray)
    }

    func statRow(title: String, count: Int, color: Color) -> some View {
        HStack {
            Circle().fill(color).frame(width: 8, height: 8)
            Text("\(title):")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            Text("\(count)")
                .font(.caption.bold())
                .foregroundColor(.white)
        }
    }
    
    var plusButton: some View {
        Image(systemName: "plus")
            .font(.title.bold())
            .foregroundColor(.white)
            .frame(width: 65, height: 65)
            .background(
                LinearGradient(colors: [Color(red: 0.2, green: 0.3, blue: 0.9), .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(Circle())
            .shadow(color: .blue.opacity(0.4), radius: 10, y: 5)
    }
}

// --- გვერდი 2: დავალების დამატება ---
struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tasks: [ToDoItem]
    @State private var text: String = ""
    
    var body: some View {
        ZStack {
            backgroundGradient
            VStack(spacing: 30) {
                TextField("What needs to be done?", text: $text)
                    .font(.title3)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.1)))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                
                Button(action: {
                    if !text.isEmpty {
                        tasks.append(ToDoItem(title: text, isCompleted: false))
                        dismiss()
                    }
                }) {
                    Text("Create Task")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                }
                Spacer()
            }
        }
        .navigationTitle("New Task")
    }
}

// --- გვერდი 3: გაფილტრული დავალებები ---
struct FilteredTaskView: View {
    @Binding var tasks: [ToDoItem]
    var filterCompleted: Bool
    
    var body: some View {
        ZStack {
            backgroundGradient
            ScrollView {
                VStack(spacing: 12) {
                    let filteredIndices = tasks.indices.filter { tasks[$0].isCompleted == filterCompleted }
                    
                    if filteredIndices.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: filterCompleted ? "checkmark.circle" : "tray")
                                .font(.system(size: 60))
                            Text("No tasks found")
                        }
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.top, 100)
                    } else {
                        ForEach(filteredIndices, id: \.self) { index in
                            HStack {
                                Text(tasks[index].title)
                                    .foregroundColor(.primary)
                                Spacer()
                                Button(action: { tasks.remove(at: index) }) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(filterCompleted ? "Completed" : "Pending")
    }
}

// საერთო ფონი
var backgroundGradient: some View {
    LinearGradient(
        gradient: Gradient(colors: [Color(red: 0.05, green: 0.05, blue: 0.15), Color(red: 0.1, green: 0.15, blue: 0.4)]),
        startPoint: .top,
        endPoint: .bottom
    ).ignoresSafeArea()
}
