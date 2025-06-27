import SwiftUI

struct YearInPixelsView: View {
    // Utilisation du manager partagé pour la persistance
    @StateObject private var manager = PixelDayManager()

    @State private var selectedDay: PixelDayModel? = nil
    @State private var showEditor = false

    let columns = 12
    let rows = 31
    let cellSize: CGFloat = 16
    let spacing: CGFloat = 3

    var body: some View {
        VStack {
            // ✅Bandeau dégradé avec titre
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                .frame(height: 100)
                .overlay(
                    VStack {
                        Spacer()
                        Text("Year In Pixels")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                    }
                )

            HStack {
                //  Grille principale
                VStack(alignment: .leading, spacing: spacing) {
                    HStack(spacing: spacing) {
                        Text("").frame(width: 16)
                        ForEach(1...columns, id: \.self) { month in
                            Text(shortMonthSymbol(month))
                                .font(.caption2)
                                .frame(width: cellSize)
                        }
                    }

                    ForEach(1...rows, id: \.self) { day in
                        HStack(spacing: spacing) {
                            Text("\(day)")
                                .font(.caption2)
                                .frame(width: 16)
                            ForEach(1...columns, id: \.self) { month in
                                let date = makeDate(day: day, month: month)
                                let mood = manager.pixelDays.first { Calendar.current.isDate($0.date, inSameDayAs: date) }

                                ZStack {
                                    Rectangle()
                                        .fill(mood?.mood.color ?? Color.gray.opacity(0.1))
                                        .frame(width: cellSize, height: cellSize)
                                        .cornerRadius(3)

                                    if let mood = mood, mood.mood != .none {
                                        Text(mood.mood.emoji)
                                            .font(.system(size: 10))
                                    }
                                }
                                .onTapGesture {
                                    if let found = manager.pixelDays.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                                        selectedDay = manager.pixelDays[found]
                                    } else {
                                        let new = PixelDayModel(date: date, mood: .none, note: "")
                                        manager.pixelDays.append(new)
                                        selectedDay = new
                                    }
                                    showEditor = true
                                }
                            }
                        }
                    }
                }

                // Panneau Mood Journal
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mood Journal")
                        .font(.subheadline)

                    DatePicker("Date", selection: Binding<Date>(
                        get: {
                            selectedDay?.date ?? Date()
                        },
                        set: { newDate in
                            if let index = manager.pixelDays.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: newDate) }) {
                                selectedDay = manager.pixelDays[index]
                            } else {
                                let new = PixelDayModel(date: newDate, mood: .none, note: "")
                                manager.pixelDays.append(new)
                                selectedDay = new
                            }
                        }
                    ), displayedComponents: .date)
                    .font(.subheadline)
                    .labelsHidden()

                    if let selected = selectedDay {
                        Text("Mood: \(selected.mood.emoji)")
                            .font(.subheadline)

                        if selected.note.isEmpty {
                            Text("No note.")
                                .italic()
                                .foregroundColor(.gray)
                        } else {
                            Text(selected.note)
                                .font(.subheadline)
                        }
                    } else {
                        Text("Select a day to view details.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Divider().padding(.vertical, 4)

                    Text("Key")
                        .font(.headline)
                    ForEach(MoodType.allCases.filter { $0 != .none }, id: \.self) { mood in
                        HStack {
                            Circle().fill(mood.color).frame(width: 10, height: 10)
                            Text("\(mood.emoji) \(mood.description)")
                                .font(.caption)
                        }
                    }

                    Spacer()
                }
                .padding(.leading, 10)
                .frame(maxWidth: 150)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showEditor) {
            if let selected = selectedDay,
               let index = manager.pixelDays.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: selected.date) }) {
                PixelEditorPanel(day: $manager.pixelDays[index]) {
                    showEditor = false
                }
            }
        }
    }

    //  Génère une date à partir du jour et du mois
    func makeDate(day: Int, month: Int) -> Date {
        let calendar = Calendar.current
        let year = Calendar.current.component(.year, from: Date())
        return calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }

    //  Formate une date en "dd/MM"
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: date)
    }

    //  Renvoie la première lettre du mois (abréviation)
    func shortMonthSymbol(_ index: Int) -> String {
        let formatter = DateFormatter()
        return formatter.shortMonthSymbols[index - 1].prefix(1).uppercased()
    }
}
