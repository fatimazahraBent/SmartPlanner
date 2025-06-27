import Foundation

class PixelDayManager: ObservableObject {
    @Published var pixelDays: [PixelDayModel] {
        didSet {
            save()
        }
    }

    private let key = "pixel_days_storage"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([PixelDayModel].self, from: data) {
            self.pixelDays = decoded
        } else {
            self.pixelDays = PixelDayModel.generateYearModel()
        }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(pixelDays) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
