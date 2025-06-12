import SwiftUI

extension Color {
    /// "#RRGGBB"、"RRGGBB"、8桁 AARRGGBB を受け取って Color を返す
    static func hex(_ hex: String) -> Color {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }

        var num: UInt64 = 0
        Scanner(string: s).scanHexInt64(&num)

        let r, g, b, a: Double
        switch s.count {
        case 6:
            a = 1
            r = Double((num & 0xFF0000) >> 16) / 255
            g = Double((num & 0x00FF00) >> 8)  / 255
            b = Double( num & 0x0000FF       ) / 255
        case 8:
            a = Double((num & 0xFF000000) >> 24) / 255
            r = Double((num & 0x00FF0000) >> 16) / 255
            g = Double((num & 0x0000FF00) >> 8 ) / 255
            b = Double( num & 0x000000FF        ) / 255
        default:
            a = 1; r = 0; g = 0; b = 0
        }

        return Color(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
