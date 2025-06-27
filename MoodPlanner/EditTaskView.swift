import SwiftUI

struct EditTaskView: View {
    var task: TaskItem                                      // Tâche à modifier
    @Binding var tasks: [TaskItem]                          // Liste des tâches
    @Environment(\.dismiss) var dismiss                     // Permet de fermer la vue
    var onDone: () -> Void                                  // Callback après sauvegarde ou annulation

    @State private var title: String                        // État du titre
    @State private var date: Date                           // État de la date (inclut heure)
    @State private var customEmoji: String?                 // Emoji personnalisé
    @State private var showEmojiPicker = false              // Affiche le sélecteur d'emoji

    //  Initialisation de l’état avec la tâche donnée
    init(task: TaskItem, tasks: Binding<[TaskItem]>, onDone: @escaping () -> Void) {
        self.task = task
        self._tasks = tasks
        self._title = State(initialValue: task.title)
        self._date = State(initialValue: task.date)
        self._customEmoji = State(initialValue: task.customEmoji)
        self.onDone = onDone
    }

    var body: some View {
        VStack(spacing: 0) {
            // Bandeau coloré en haut avec le titre
            LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 110)
                .overlay(
                    Text("Edit Task")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(.top, 40)
                )

            Form {
                // Section avec les champs de la tâche
                Section {
                    HStack {
                        TextField("Task title", text: $title)
                        Button {
                            showEmojiPicker = true
                        } label: {
                            Text(customEmoji ?? "🙂")
                                .font(.title2)
                                .padding(6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }

                    //  Sélection de la date et de l’heure de la tâche
                    DatePicker("Select Date and Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                //  Section boutons d'action
                Section {
                    Button("Save Changes") {
                        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                            tasks[index].title = title
                            tasks[index].date = date
                            tasks[index].customEmoji = customEmoji
                        }
                        onDone()
                        dismiss()
                    }

                    Button("Cancel", role: .cancel) {
                        onDone()
                        dismiss()
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .top) // Permet au bandeau de dépasser le haut de l'écran

        //  Affiche le sélecteur d'emoji si nécessaire
        .sheet(isPresented: $showEmojiPicker) {
            EmojiSelectorView(selectedEmoji: Binding(
                get: { customEmoji },
                set: { customEmoji = $0 }
            ))
        }
    }
}
