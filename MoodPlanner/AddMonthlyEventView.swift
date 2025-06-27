import SwiftUI

// Vue pour ajouter un événement mensuel
struct AddMonthlyEventView: View {
    @Environment(\.dismiss) var dismiss                  // Permet de fermer la vue
    @Binding var events: [MonthlyEvent]                  // Liste des événements à laquelle on ajoute

    // États pour les champs du formulaire
    @State private var name = ""                         // Titre de l’événement
    @State private var color = Color.blue                // Couleur choisie
    @State private var emoji: String? = nil              // Emoji associé
    @State private var startDate = Date()                // Date de début
    @State private var endDate = Date()                  // Date de fin
    @State private var showEmojiPicker = false           // Contrôle l’affichage du sélecteur d’emoji

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                //  Espace vide réservé au bandeau en haut
                Color.clear.frame(height: 100)

                // Formulaire pour saisir les informations de l’événement
                Form {
                    // SECTION : détails de l’événement
                    Section(header: Text("Event Details")) {
                        HStack {
                            // Champ texte pour le nom de l’événement
                            TextField("Event title", text: $name)

                            // Bouton pour ouvrir le sélecteur d’emoji
                            Button {
                                showEmojiPicker = true
                            } label: {
                                Text(emoji ?? "🙂")         // Affiche l’emoji sélectionné ou un emoji par défaut
                                    .font(.title2)
                                    .padding(6)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }

                        // Sélecteur de couleur pour l’événement
                        ColorPicker("Pick a color", selection: $color)

                        // Sélecteur de date de début
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)

                        // Sélecteur de date de fin
                        DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
                    }

                    // SECTION : bouton d’enregistrement
                    Section {
                        Button("Save") {
                            // Conversion de la couleur en hexadécimal pour stockage
                            let hex = UIColor(color).toHex ?? "#999999"

                            // Création du nouvel événement
                            let newEvent = MonthlyEvent(
                                name: name,
                                colorHex: hex,
                                emoji: emoji,
                                startDate: startDate,
                                endDate: endDate
                            )

                            // Ajoute l’événement à la liste
                            events.append(newEvent)
                            dismiss() // Ferme la vue
                        }
                        // Désactivé si le nom est vide ou les dates sont invalides
                        .disabled(name.isEmpty || startDate > endDate)
                    }
                }

                // Affiche le sélecteur d’emoji quand nécessaire
                .sheet(isPresented: $showEmojiPicker) {
                    EmojiSelectorView(selectedEmoji: $emoji)
                }
            }

            // Bandeau supérieur coloré avec le titre
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 110)
            .overlay(
                Text("New Event")                           // Titre centré
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 50)
            )
            .edgesIgnoringSafeArea(.top)                   // Étend le fond sous la barre système
        }
    }
}
