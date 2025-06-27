import SwiftUI

enum MoodType: String, CaseIterable, Codable {
    case happy, sad, stressed, excited, tired, neutral, none

    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .sad: return "😢"
        case .stressed: return "😣"
        case .excited: return "😆"
        case .tired: return "🥱"
        case .neutral: return "🙂"
        case .none: return "?"
        }
    }

    var color: Color {
        switch self {
        case .happy: return .yellow
        case .sad: return .blue
        case .stressed: return .red
        case .excited: return .orange
        case .tired: return .gray
        case .neutral: return .green
        case .none: return Color.gray.opacity(0.1)
        }
    }

    var description: String {
        switch self {
        case .happy: return "Happy"
        case .sad: return "Sad"
        case .stressed: return "Stressed"
        case .excited: return "Excited"
        case .tired: return "Tired"
        case .neutral: return "Neutral"
        case .none: return "Not set"
        }
    }
}
