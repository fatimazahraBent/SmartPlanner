import SwiftUI
import UIKit

/// Data model for a monthly event
struct MonthlyEvent: Identifiable, Codable {
    var id = UUID()
    var name: String
    var colorHex: String
    var emoji: String?
    var startDate: Date
    var endDate: Date

    var color: Color {
        Color(hex: colorHex)
    }
}

/// Extension to init Color from hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = (
            (int >> 16) & 0xFF,
            (int >> 8) & 0xFF,
            int & 0xFF
        )
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

/// Centralized UIColor toHex extension
extension UIColor {
    var toHex: String? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        let rgb = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "%06x", rgb)
    }
}
