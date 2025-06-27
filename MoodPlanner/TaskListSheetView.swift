import SwiftUI

struct TaskListSheetView: View {
    @Binding var tasks: [TaskItem]
    let date: Date
    var onDismiss: (() -> Void)? = nil
    @Environment(\.dismiss) var dismiss
    @State private var taskBeingEdited: TaskItem?
    @State private var showEditSheet = false

    var body: some View {
        VStack(spacing: 0) {
            // En-tête coloré
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 100)
            .overlay(
                VStack {
                    Spacer()
                    Text("Tasks for Day")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 12)
                }
            )

            // Liste des tâches
            List {
                ForEach(tasksFor(date)) { task in
                    HStack {
                        Text("\(task.displayEmoji) \(task.title)")
                            .strikethrough(task.isCompleted)
                            .foregroundColor(task.isCompleted ? .gray : .primary)

                        Spacer()

                        Menu {
                            Button(task.isCompleted ? "Mark as Incomplete" : "Mark as Completed") {
                                toggleCompletion(task.id)
                            }

                            Button("Edit") {
                                taskBeingEdited = task
                                showEditSheet = true
                            }

                            Button(role: .destructive) {
                                deleteTask(task.id)
                            } label: {
                                Text("Delete")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title3)
                        }
                    }
                }
            }
        }
        .onDisappear {
            onDismiss?() // Important : déclenche la mise à jour dans le calendrier
        }
        .sheet(item: $taskBeingEdited) { task in
            EditTaskView(task: task, tasks: $tasks) {
                taskBeingEdited = nil
                onDismiss?() // Mise à jour immédiate après modification
            }
        }
    }

    // MARK: - Fonctions

    private func tasksFor(_ date: Date) -> [TaskItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: date)
        return tasks.filter { formatter.string(from: $0.date) == dateStr }
    }

    private func toggleCompletion(_ id: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted.toggle()
        }
        onDismiss?() // Mise à jour après changement de statut
    }

    private func deleteTask(_ id: UUID) {
        tasks.removeAll { $0.id == id }
        onDismiss?() // Mise à jour après suppression
    }
}
