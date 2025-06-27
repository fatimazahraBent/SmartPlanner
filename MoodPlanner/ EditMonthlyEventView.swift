import SwiftUI

struct EditMonthlyEventView: View {
    @Environment(\.dismiss) var dismiss                       // Pour fermer la vue
    @Binding var events: [MonthlyEvent]                       // Liste des événements à modifier
    var event: MonthlyEvent                                   // Événement à éditer
    var onSave: () -> Void                                    // Callback quand on sauvegarde

    // États locaux pour les champs du formulaire
    @State private var title: String                          // Titre de l'événement
    @State private var selectedEmoji: String?                 // Emoji sélectionné
    @State private var color: Color                           // Couleur de l'événement
    @State private var startDate: Date                        // Date de début
    @State private var endDate: Date                          // Date de fin
    @State private var showEmojiPicker = false                // Contrôle l'affichage du sélecteur d’emoji

    // Initialiseur avec état initial basé sur l’événement reçu
    init(event: MonthlyEvent, events: Binding<[MonthlyEvent]>, onSave: @escaping () -> Void) {
        self.event = event
        self._events = events
        self._title = State(initialValue: event.name)
        self._selectedEmoji = State(initialValue: event.emoji)
        self._color = State(initialValue: event.color)
        self._startDate = State(initialValue: event.startDate)
        self._endDate = State(initialValue: event.endDate)
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            // Bandeau supérieur avec fond dégradé et titre
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                Text("Edit Event")                            // Titre affiché au centre
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(height: 110)
            .edgesIgnoringSafeArea(.top)                      // Étend le bandeau sous la barre système

            // Formulaire de modification
            Form {
                // Section pour les informations principales
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)          // Champ pour modifier le titre

                    // Bouton pour choisir un emoji
                    Button {
                        showEmojiPicker = true
                    } label: {
                        Text(selectedEmoji ?? "🙂")           // Emoji affiché
                            .font(.largeTitle)
                            .frame(width: 60, height: 60)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(12)
                    }
                }

                // Choix de la couleur de l’événement
                ColorPicker("Color", selection: $color)

                // Date de début de l’événement
                DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])

                // Date de fin de l’événement
                DatePicker("End Date", selection: $endDate, displayedComponents: [.date])

                // Boutons d’action : sauvegarde ou suppression
                Section {
                    // Bouton de sauvegarde
                    Button("Save Changes") {
                        // Met à jour l’événement dans la liste
                        if let index = events.firstIndex(where: { $0.id == event.id }) {
                            events[index].name = title
                            events[index].emoji = selectedEmoji
                            events[index].colorHex = UIColor(color).toHex ?? "000000"
                            events[index].startDate = startDate
                            events[index].endDate = endDate
                        }
                        onSave()
                        dismiss()                             // Ferme la vue
                    }

                    // Bouton de suppression
                    Button("Delete Event", role: .destructive) {
                        events.removeAll { $0.id == event.id } // Supprime l'événement
                        onSave()
                        dismiss()
                    }
                }
            }

            // Feuille modale pour le sélecteur d’emoji
            .sheet(isPresented: $showEmojiPicker) {
                EmojiSelectorView(selectedEmoji: $selectedEmoji)
            }
        }
    }
}
