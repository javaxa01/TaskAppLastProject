//
//  TaskViewModel.swift
//  TaskAppLastProject
//
//  Created by Saba Javakhishvili on 18.02.26.
//

import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet { saveTasks() }
    }

    private let key = "tasks_key"

    init() {
        loadTasks()
    }

    func addTask(title: String) {
        let task = Task(title: title)
        tasks.append(task)
    }

    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    var activeTasks: [Task] {
        tasks.filter { !$0.isCompleted }
    }

    var completedTasks: [Task] {
        tasks.filter { $0.isCompleted }
    }

    // MARK: - Persistence
    private func saveTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([Task].self, from: data) else { return }
        tasks = saved
    }
}

