import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasks: [TaskItem] = [] {
        didSet {
            saveTasks()
        }
    }

    private let key = "SavedTasks"

    init() {
        loadTasks()
    }

    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([TaskItem].self, from: data) {
            self.tasks = decoded
        }
    }
}
