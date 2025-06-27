import SwiftUI

// Vue permettant à l'utilisateur de choisir un emoji dans une grille organisée par thèmes
struct EmojiSelectorView: View {
    @Binding var selectedEmoji: String?              // Emoji sélectionné (lié à la vue appelante)
    @Environment(\.dismiss) var dismiss              // Permet de fermer la vue modale

    // Dictionnaire de catégories d’emojis (titre : liste d’emojis)
    private let emojiCategories: [String: [String]] = [
        "Fun": ["🍻", "🍾", "🎊", "🍕", "🍔", "🍟"],
        "Mood": ["😭", "😂", "✨", "🥰", "🔥", "🙏"],
        "Positive": ["😄", "😁", "😍", "👌🏻"],
        "Study": ["👨‍🎓", "👩‍🎓", "📚", "🧠", "🏫", "💻"],
        "Travel": ["✈️", "🏖️", "☀️", "🌊", "🏝️", "🧳", "🗺️", "🚢", "🏨", "🍹", "🌴"]
    ]

    var body: some View {
        //  Vue avec navigation (permet titre et bouton Cancel)
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Boucle sur chaque catégorie (ordre alphabétique)
                    ForEach(emojiCategories.keys.sorted(), id: \.self) { category in
                        VStack(alignment: .leading, spacing: 6) {
                            // Titre de la catégorie (ex: Fun, Mood, Travel)
                            Text(category)
                                .font(.headline)
                                .foregroundColor(.secondary)

                            //  Grille de 6 emojis par ligne
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                                ForEach(emojiCategories[category]!, id: \.self) { emoji in
                                    Text(emoji)
                                        .font(.largeTitle)
                                        .frame(width: 44, height: 44)
                                        .background(
                                            Circle()
                                                .fill(selectedEmoji == emoji ? Color.blue.opacity(0.3) : Color.clear)
                                        )
                                        .onTapGesture {
                                            selectedEmoji = emoji // Sélectionne l'emoji
                                            dismiss()              // Ferme la vue
                                        }
                                }
                            }
                        }
                    }
                }
                .padding() // Marge intérieure
            }
            .navigationTitle("Choose Emoji")
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
