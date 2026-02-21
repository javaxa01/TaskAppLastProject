
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
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach($tasks) { $task in
                            taskRow(task: $task) // ვიძახებთ განახლებულ ფუნქციას
                        }
                    }
                    .padding(.horizontal)
                }

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
    
    // --- განახლებული Task Row დედლაინით ---
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

    // დანარჩენი დამხმარე კომპონენტები (headerSection, statisticsCard და ა.შ.) უცვლელია...
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("MY DAILY TASKS").font(.system(size: 14, weight: .black)).kerning(2)
                Spacer()
                ZStack {
                    Image(systemName: "calendar").font(.system(size: 28))
                    Text("\(Calendar.current.component(.day, from: Date()))").font(.system(size: 10, weight: .bold)).offset(y: 3)
                }
            }
            .foregroundColor(.white.opacity(0.8))
            .padding([.horizontal, .top])
            
            Text(currentDateString).font(.system(size: 34, weight: .heavy)).foregroundColor(.white).padding(.leading)
            
            TimelineView(.periodic(from: .now, by: 1.0)) { context in
                Text(context.date, style: .time).font(.system(size: 20, weight: .light)).foregroundColor(.white.opacity(0.7)).padding(.leading)
            }
        }
    }

    var statisticsCard: some View {
        let completed = tasks.filter { $0.isCompleted }.count
        let total = tasks.count
        let progress = total > 0 ? Double(completed) / Double(total) : 0
        
        return VStack(alignment: .leading, spacing: 10) {
            Text("Progress Status").font(.headline).foregroundColor(.white)
            HStack {
                VStack(alignment: .leading) {
                    Text("Completed: \(completed)").font(.caption).foregroundColor(.green)
                    Text("Pending: \(total - completed)").font(.caption).foregroundColor(.orange)
                }
                Spacer()
                ZStack {
                    Circle().stroke(Color.white.opacity(0.1), lineWidth: 5)
                    Circle().trim(from: 0, to: progress).stroke(Color.cyan, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(progress * 100))%").font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                }.frame(width: 50, height: 50)
            }
        }
        .padding().background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.12))).padding(.horizontal)
    }

    func filterIcon(title: String, icon: String, active: Bool) -> some View {
        VStack {
            Image(systemName: icon).font(.system(size: 20))
            Text(title).font(.caption2)
        }.foregroundColor(active ? .white : .gray)
    }
    
    var plusButton: some View {
        Image(systemName: "plus").font(.title.bold()).foregroundColor(.white).frame(width: 60, height: 60)
            .background(Circle().fill(Color.blue)).shadow(radius: 5)
    }
}
