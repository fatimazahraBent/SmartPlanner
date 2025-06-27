import Foundation

// Modèle de données représentant une journée avec humeur et note
struct PixelDayModel: Identifiable, Codable {
    var id = UUID()  // Identifiant unique pour chaque jour
    var date: Date   // La date représentée
    var mood: MoodType // L’humeur associée à ce jour (enum personnalisée)
    var note: String // Une note facultative pour ce jour (journal, pensée…)

    // Génère automatiquement un tableau de tous les jours de l’année en cours
    static func generateYearModel() -> [PixelDayModel] {
        let calendar = Calendar.current // On utilise le calendrier actuel
        let year = calendar.component(.year, from: Date()) // On récupère l’année actuelle
        var days: [PixelDayModel] = [] // Tableau vide pour stocker les jours

        // 🔁 Pour chaque mois de l’année (1 à 12)
        for month in 1...12 {
            // On crée une date correspondant au début du mois
            if let dateInMonth = calendar.date(from: DateComponents(year: year, month: month)),
               // On récupère le nombre de jours dans ce mois
               let range = calendar.range(of: .day, in: .month, for: dateInMonth) {
                
                // 🔁 Pour chaque jour du mois
                for day in range {
                    // On crée une date complète pour ce jour
                    if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) {
                        // On ajoute une entrée avec humeur "none" et note vide
                        days.append(PixelDayModel(date: date, mood: .none, note: ""))
                    }
                }
            }
        }

        return days 
    }
}
