import SwiftUI

// Vue personnalisée du calendrier mensuel
struct CustomCalendarView: View {
    @Binding var selectedDate: Date                   // La date sélectionnée
    @Binding var tasks: [TaskItem]                    // Liste des tâches
    @Binding var events: [MonthlyEvent]               // Liste des événements mensuels

    @State private var showEditEvent: Bool = false    // Contrôle la feuille d’édition d’événement
    @State private var eventToEdit: MonthlyEvent?     // L’événement à éditer
    @State private var showTaskSheet: Bool = false    // Contrôle la feuille des tâches
    @State private var refreshId = UUID()             // Pour forcer la mise à jour de la vue

    //  Configuration du calendrier pour commencer la semaine le lundi
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2 // Lundi
        return cal
    }

    // 7 colonnes pour les jours de la semaine
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack(spacing: 12) {
            calendarHeader                   // Titre mois + boutons navigation
            daySymbolsHeader                 // En-tête des jours : L M M J V S D

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(generateDaysInMonth(for: selectedDate), id: \.self) { date in
                    calendarCell(for: date)  // Cellule de chaque jour
                }
            }
            .id(refreshId)
            .padding(.horizontal)

            // Section des événements mensuels
            ScrollView {
                eventCardsSection
                    .padding(.bottom, 30)
            }
        }
        // Feuille pour modifier un événement
        .sheet(isPresented: $showEditEvent) {
            EditMonthlyEventView(
                event: eventToEdit ?? events.first!,
                events: $events,
                onSave: {
                    showEditEvent = false
                }
            )
        }
        // Feuille des tâches d’un jour
        .sheet(isPresented: $showTaskSheet) {
            TaskListSheetView(tasks: $tasks, date: selectedDate) {
                refreshId = UUID() // Forcer la mise à jour après modifications
            }
        }
        .background(Color(.systemGroupedBackground)) // Fond doux
    }

    //  En-tête du calendrier avec navigation
    private var calendarHeader: some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy" // Mois Année

        return HStack {
            // Bouton précédent
            Button(action: { changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .padding(8)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            }

            Spacer()

            // Titre actuel (mois année)
            Text(formatter.string(from: selectedDate).capitalized)
                .font(.title2).bold()

            Spacer()

            // Bouton suivant
            Button(action: { changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .padding(8)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            }
        }
        .padding(.horizontal)
    }

    // En-tête des jours de la semaine (L M M J V S D)
    private var daySymbolsHeader: some View {
        let symbols = calendar.shortWeekdaySymbols
        let reordered = Array(symbols.suffix(from: calendar.firstWeekday - 1) + symbols.prefix(calendar.firstWeekday - 1))

        return HStack {
            ForEach(reordered, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }

    //  Génère chaque case du calendrier
    private func calendarCell(for date: Date) -> some View {
        // Ignore les jours hors du mois
        guard calendar.component(.month, from: date) == calendar.component(.month, from: selectedDate) else {
            return AnyView(Color.clear.frame(height: 50))
        }

        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isToday = calendar.isDateInToday(date)

        // Filtre les tâches non complétées du jour
        let dayTasks = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) && !$0.isCompleted }

        // Filtre les événements actifs sur ce jour
        let dayEvents = events.filter {
            calendar.isDate(date, inSameDayOrAfter: $0.startDate) &&
            calendar.isDate(date, inSameDayOrBefore: $0.endDate)
        }

        // Prend la couleur du premier événement
        let eventColor = dayEvents.first?.color ?? .clear

        return AnyView(
            VStack(spacing: 3) {
                VStack(spacing: 2) {
                    // Numéro du jour
                    Text("\(calendar.component(.day, from: date))")
                        .fontWeight(isSelected ? .bold : .regular)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(isSelected ? Color.blue.opacity(0.3) : Color.clear)
                        )

                    // Affiche les emojis des tâches du jour
                    if !dayTasks.isEmpty {
                        Text(dayTasks.prefix(5).map { $0.displayEmoji }.joined())
                            .font(.caption2)
                    }
                }

                // Petits cercles pour les événements
                if !dayEvents.isEmpty {
                    HStack(spacing: 3) {
                        ForEach(dayEvents.prefix(3), id: \.id) { event in
                            Circle()
                                .fill(event.color)
                                .frame(width: 5, height: 5)
                        }
                    }
                }
            }
            .padding(6)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        isSelected ? Color.blue.opacity(0.3) :
                        !dayEvents.isEmpty ? eventColor.opacity(0.2) :
                        isToday ? Color.blue.opacity(0.08) :
                        Color.white
                    )
            )
            .onTapGesture {
                selectedDate = date         // Met à jour la date sélectionnée
                showTaskSheet = true        // Ouvre la feuille de tâches
            }
        )
    }

    //  Section affichant les événements du mois
    private var eventCardsSection: some View {
        let currentMonth = calendar.component(.month, from: selectedDate)
        let currentYear = calendar.component(.year, from: selectedDate)

        // Filtrer les événements du mois en cours
        let monthEvents = events.filter {
            calendar.component(.month, from: $0.startDate) == currentMonth &&
            calendar.component(.year, from: $0.startDate) == currentYear
        }.sorted(by: { $0.startDate < $1.startDate })

        return Group {
            if !monthEvents.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Upcoming Events")
                        .font(.headline)
                        .padding(.horizontal)

                    // Cartes des événements
                    ForEach(monthEvents, id: \.id) { event in
                        HStack(spacing: 12) {
                            Text(event.emoji ?? "📌")
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(event.name)
                                    .font(.body).bold()
                                Text(formattedDate(event.startDate))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Circle()
                                .fill(event.color)
                                .frame(width: 8, height: 8)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                        .onTapGesture {
                            eventToEdit = event       // Stocke l’événement sélectionné
                            showEditEvent = true      // Affiche la feuille d’édition
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
    }

    //  Change le mois affiché
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }

    // Formate une date lisible
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }

    //  Génère tous les jours affichés dans la grille du mois
    private func generateDaysInMonth(for date: Date) -> [Date] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }

        var days: [Date] = []

        // Décalage pour commencer le mois au bon jour
        let weekday = calendar.component(.weekday, from: monthStart)
        let offset = (weekday - calendar.firstWeekday + 7) % 7

        // Ajoute les jours du mois précédent pour compléter la 1re ligne
        for i in 0..<offset {
            if let prevDate = calendar.date(byAdding: .day, value: -offset + i, to: monthStart) {
                days.append(prevDate)
            }
        }

        // Jours du mois actuel
        for day in range {
            if let dayDate = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(dayDate)
            }
        }

        return days
    }
}

// Extensions utilitaires
extension Calendar {
    // Comparaison incluant égalité
    func isDate(_ d1: Date, inSameDayOrAfter d2: Date) -> Bool {
        return self.startOfDay(for: d1) >= self.startOfDay(for: d2)
    }

    func isDate(_ d1: Date, inSameDayOrBefore d2: Date) -> Bool {
        return self.startOfDay(for: d1) <= self.startOfDay(for: d2)
    }
}
