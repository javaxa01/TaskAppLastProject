import SwiftUI

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
                
                // ფილტრაციის სექცია
                HStack(spacing: 30) {
                    Spacer()
                    filterIcon(title: "All", icon: "list.bullet", active: true)
                    
                    NavigationLink(destination: FilteredTaskView(tasks: $tasks, filterCompleted: true)) {
                        filterIcon(title: "Done", icon: "checkmark.seal.fill", active: false)
                    }
                    
                    NavigationLink(destination: FilteredTaskView(tasks: $tasks, filterCompleted: false)) {
                        filterIcon(title: "Pending", icon: "clock.badge.exclamationmark", active: false)
                    }
                    Spacer()
                }
                .padding(.vertical)
                
                statisticsCard
                
                // დავალებების სია
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach($tasks) { $task in
                            taskRow(task: $task)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
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
    
    // MARK: - Components
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("MY DAILY TASKS")
                    .font(.system(size: 14, weight: .black))
                    .kerning(2)
                Spacer()
                // კალენდრის აიქონი დღევანდელი რიცხვით
                ZStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 28))
                    Text("\(Calendar.current.component(.day, from: Date()))")
                        .font(.system(size: 10, weight: .bold))
                        .offset(y: 3)
                }
            }
            .foregroundColor(.white.opacity(0.8))
            .padding([.horizontal, .top])
            
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
        let completed = tasks.filter { $0.isCompleted }.count
        let total = tasks.count
        let progress = total > 0 ? Double(completed) / Double(total) : 0
        
        return VStack(spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Progress")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("\(completed) of \(total) tasks completed")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(.cyan)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 12)
                    
                    Capsule()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.cyan, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: geometry.size.width * CGFloat(progress), height: 12)
                        .shadow(color: Color.cyan.opacity(0.5), radius: 5, x: 0, y: 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progress)
                }
            }
            .frame(height: 12)
            
            HStack(spacing: 15) {
                statMiniCard(title: "Pending", count: total - completed, color: .orange)
                statMiniCard(title: "Done", count: completed, color: .green)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
    
    func taskRow(task: Binding<ToDoItem>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.wrappedValue.title)
                    .font(.system(size: 16, weight: .medium))
                    .strikethrough(task.wrappedValue.isCompleted)
                    .foregroundColor(task.wrappedValue.isCompleted ? .gray : .black)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(task.wrappedValue.dueDate, style: .date)
                        .font(.caption2)
                }
                .foregroundColor(.gray.opacity(0.8))
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
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Helpers
    
    func statMiniCard(title: String, count: Int, color: Color) -> some View {
        HStack {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(title).font(.caption).foregroundColor(.white.opacity(0.7))
            Spacer()
            Text("\(count)").font(.caption.bold()).foregroundColor(.white)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Capsule().fill(Color.black.opacity(0.2)))
    }
    
    func filterIcon(title: String, icon: String, active: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(title)
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundColor(active ? .cyan : .white.opacity(0.4))
    }
    
    var plusButton: some View {
        Image(systemName: "plus")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 60, height: 60)
            .background(
                Circle()
                    .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom))
            )
            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}
