import SwiftUI

@main
struct TaskApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
struct ToDoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}

struct ContentView: View {
    // საწყისი მონაცემები
    @State private var tasks: [ToDoItem] = [
        ToDoItem(title: "Add Your Todo Item Here", isCompleted: false),
        ToDoItem(title: "Add Your Todo Item Here", isCompleted: false),
        ToDoItem(title: "Add Your Todo Item Here", isCompleted: true)
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
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(alignment: .leading) {
                headerSection
                
                // ფილტრის ღილაკები
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("All").font(.caption2)
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink(destination: CompletedTaskView(tasks: tasks)) {
                        VStack {
                            Image(systemName: "checkmark")
                            Text("Completed").font(.caption2)
                        }
                    }
                    .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.vertical)

                // დავალებების სია
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach($tasks) { $task in
                            HStack {
                                Text(task.title)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Spacer()
                                Image(systemName: "pencil").foregroundColor(.black)
                                Button(action: { task.isCompleted.toggle() }) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                                        .foregroundColor(.black)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }

                // დამატების ღილაკი
                HStack {
                    Spacer()
                    NavigationLink(destination: AddTaskView(tasks: $tasks)) {
                        Image(systemName: "plus")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
    }
    
    var headerSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("TODO TASK")
                    .font(.headline)
                Spacer()
                Image(systemName: "calendar")
                    .overlay(Text("15").font(.system(size: 8)).offset(y: 2))
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.top, 20)
            
            Text("25.2.2024")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading)
            
            HStack {
                Spacer()
                Text("9:41")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.trailing)
            }
        }
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
                TextField("Detail", text: $text)
                    .padding(.bottom, 5)
                    .overlay(Rectangle().frame(height: 1).foregroundColor(.white.opacity(0.5)), alignment: .bottom)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.top, 100)
                
                Button(action: {
                    if !text.isEmpty {
                        tasks.append(ToDoItem(title: text, isCompleted: false))
                        dismiss()
                    }
                }) {
                    Text("ADD")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.1, green: 0.1, blue: 0.3))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                Spacer()
            }
        }
        .navigationTitle("Add Task")
        .preferredColorScheme(.dark)
    }
}

// --- გვერდი 3: დასრულებული დავალებები ---
struct CompletedTaskView: View {
    var tasks: [ToDoItem]
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(tasks.filter { $0.isCompleted }) { task in
                            Text(task.title)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "list.bullet")
                    Text("All").font(.caption2)
                }
                .foregroundColor(.black)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Completed Task")
    }
}

// საერთო ფონი
var backgroundGradient: some View {
    LinearGradient(
        gradient: Gradient(colors: [Color.black, Color(red: 0.2, green: 0.2, blue: 0.6), Color(red: 0.5, green: 0.5, blue: 0.8)]),
        startPoint: .top,
        endPoint: .bottom
    ).ignoresSafeArea()
}

#Preview {
    ContentView()
}
