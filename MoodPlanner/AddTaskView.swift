import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss                      // Permet de fermer la vue
    @Binding var tasks: [TaskItem]                           // Liste des tâches à modifier

    @State private var title = ""                            // Titre de la tâche
    @State private var date = Date()                         // Date et heure de la tâche
    @State private var customEmoji: String? = nil            // Emoji personnalisé (optionnel)
    @State private var showEmojiPicker = false               // Contrôle l'affichage du sélecteur d'emoji

    var body: some View {
        ZStack(alignment: .top) {
            //  Contenu principal de la vue
            VStack {
                Color.clear.frame(height: 100) // Espace réservé sous l'en-tête

                Form {
                    //  Champ de texte pour le titre + bouton emoji
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

                    //Sélection de la date ET de l’heure
                    DatePicker("Select Date and Time", selection: $date, displayedComponents: [.date, .hourAndMinute])

                    // Bouton pour ajouter la tâche
                    Button("Add Task") {
                        // Crée une nouvelle tâche avec l'heure sélectionnée
                        let newTask = TaskItem(id: UUID(), title: title, customEmoji: customEmoji, date: date)
                        tasks.append(newTask) // Ajoute la tâche à la liste
                        dismiss()             // Ferme la vue
                    }
                    .disabled(title.isEmpty) // Désactive si le titre est vide
                }
            }

            // Bandeau coloré avec le titre "New Task"
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                Text("New Task")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(height: 100)
            .edgesIgnoringSafeArea(.top) // Pour que le bandeau aille jusqu’en haut de l’écran
        }

        //  Affiche le sélecteur d'emoji si demandé
        .sheet(isPresented: $showEmojiPicker) {
            EmojiSelectorView(selectedEmoji: Binding(
                get: { customEmoji },
                set: { customEmoji = $0 }
            ))
        }
    }
}
