import Foundation
import SwiftUI

class EventManager: ObservableObject {
    @Published var events: [MonthlyEvent] = [] {
        didSet {
            saveEvents()
        }
    }

    private let key = "SavedMonthlyEvents"

    init() {
        loadEvents()
    }

    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func loadEvents() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([MonthlyEvent].self, from: data) {
            self.events = decoded
        }
    }
}
