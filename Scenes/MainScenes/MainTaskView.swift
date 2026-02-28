
import SwiftUI

struct MainTaskView: View {
    @Binding var tasks: [ToDoItem]
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    
                    headerSection
                        .padding(.top, geometry.safeAreaInsets.top > 0 ? 10 : 20)
                        .padding(.horizontal)
                    
                  
                    HStack {
                        Spacer()
                        filterIcon(title: "All", icon: "list.bullet", active: true)
                        Spacer()
                        NavigationLink(destination: FilteredTaskView(tasks: $tasks, filterCompleted: true)) {
                            filterIcon(title: "Done", icon: "checkmark.seal.fill", active: false)
                        }
                        Spacer()
                        NavigationLink(destination: FilteredTaskView(tasks: $tasks, filterCompleted: false)) {
                            filterIcon(title: "Pending", icon: "clock.badge.exclamationmark", active: false)
                        }
                        Spacer()
                    }
                    .padding(.vertical, geometry.size.height * 0.02)

                    statisticsCard
                        .padding(.horizontal)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            if tasks.isEmpty {
                                emptyStateView
                            } else {
                                ForEach($tasks) { $task in
                                    taskRow(task: $task)
                                }
                            }
                        }
                        .padding(.all, 16)
                    }
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddTaskView(tasks: $tasks)) {
                            plusButton
                        }
                        Spacer()
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 5 : 20)
                }
            }
        }
        .navigationBarHidden(true)
    }


    var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("MY DAILY TASKS")
                .font(.system(size: 12, weight: .black))
                .kerning(2)
                .foregroundColor(.white.opacity(0.6))
            
            Text(Date(), style: .date)
                .font(.system(size: 32, weight: .heavy))
                .foregroundColor(.white)
                .minimumScaleFactor(0.8)
            
            TimelineView(.periodic(from: .now, by: 1.0)) { context in
                Text(context.date, style: .time)
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }

    func taskRow(task: Binding<ToDoItem>) -> some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.wrappedValue.title)
                    .font(.system(size: 16, weight: .semibold))
                    .strikethrough(task.wrappedValue.isCompleted)
                    .foregroundColor(task.wrappedValue.isCompleted ? .gray : .black)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                    Text(task.wrappedValue.dueDate, style: .date)
                }
                .font(.caption2)
                .foregroundColor(.gray.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: { withAnimation { task.wrappedValue.isCompleted.toggle() } }) {
                Image(systemName: task.wrappedValue.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.wrappedValue.isCompleted ? .green : .gray)
                    .frame(width: 44, height: 44) // მოსახერხებელია თითისთვის
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    var statisticsCard: some View {
        let completed = tasks.filter { $0.isCompleted }.count
        let total = tasks.count
        let progress = total > 0 ? Double(completed) / Double(total) : 0
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("Progress Status")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Circle().fill(Color.green).frame(width: 8, height: 8)
                        Text("Completed: \(completed)").font(.caption).foregroundColor(.white.opacity(0.8))
                    }
                    HStack {
                        Circle().fill(Color.orange).frame(width: 8, height: 8)
                        Text("Pending: \(total - completed)").font(.caption).foregroundColor(.white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 5)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.cyan, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(width: 50, height: 50)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.12)))
    }

    var emptyStateView: some View {
        VStack(spacing: 10) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.largeTitle)
            Text("No tasks yet")
        }
        .foregroundColor(.white.opacity(0.4))
        .padding(.top, 50)
    }

    func filterIcon(title: String, icon: String, active: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 22))
            Text(title).font(.system(size: 10, weight: .bold))
        }
        .foregroundColor(active ? .cyan : .white.opacity(0.4))
    }

    var plusButton: some View {
        Image(systemName: "plus")
            .font(.title.bold())
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .background(Circle().fill(Color.blue))
            .shadow(color: .blue.opacity(0.4), radius: 8, y: 4)
    }
}
