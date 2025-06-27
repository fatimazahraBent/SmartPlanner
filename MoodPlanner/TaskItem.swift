import SwiftUI

/// Data model for tasks
struct TaskItem: Identifiable, Codable {
    var id: UUID
    var title: String
    var customEmoji: String?
    var isCompleted: Bool = false
    var date: Date
    var time: Date = Date()

    /// Emoji to display based on custom emoji or inferred from title
    var displayEmoji: String {
        if let emoji = customEmoji, !emoji.isEmpty {
            return emoji
        } else {
            return TaskItem.emojiForTitle(title)
        }
    }

    /// Returns an emoji based on keywords in the task title
    static func emojiForTitle(_ title: String) -> String {
        let lower = title.lowercased()
        if lower.contains("gym") || lower.contains("sport") || lower.contains("fitness") {
            return "🏋️"
        }
        if lower.contains("run") || lower.contains("jogging") {
            return "🏃"
        }
        if lower.contains("study") || lower.contains("homework") || lower.contains("exam") {
            return "📚"
        }
        if lower.contains("party") || lower.contains("celebration") {
            return "🎉"
        }
        if lower.contains("work") || lower.contains("job") {
            return "💼"
        }
        if lower.contains("dinner") || lower.contains("eat") || lower.contains("lunch") || lower.contains("meal") {
            return "🍽️"
        }
        if lower.contains("friend") || lower.contains("girl") || lower.contains("boyfriend") {
            return "👯‍♀️"
        }
        if lower.contains("sleep") || lower.contains("nap") {
            return "🛌"
        }
        if lower.contains("rencard") || lower.contains("date") || lower.contains("love") {
            return "💖"
        }
        if lower.contains("call") || lower.contains("phone") || lower.contains("parent") {
            return "☎️"
        }
        return "📝"
    }
}
