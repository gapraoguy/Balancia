import SwiftUI

extension Color {
    /// "#RRGGBB" や "RRGGBB"、8桁ARGB "AARRGGBB" に対応
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }

        var hexNumber: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&hexNumber)

        let r, g, b, a: Double
        switch hexString.count {
        case 6:
            a = 1
            r = Double((hexNumber & 0xFF0000) >> 16) / 255
            g = Double((hexNumber & 0x00FF00) >> 8) / 255
            b = Double( hexNumber & 0x0000FF       ) / 255
        case 8:
            a = Double((hexNumber & 0xFF000000) >> 24) / 255
            r = Double((hexNumber & 0x00FF0000) >> 16) / 255
            g = Double((hexNumber & 0x0000FF00) >> 8 ) / 255
            b = Double( hexNumber & 0x000000FF        ) / 255
        default:
            // 不正な文字列なら黒にフォールバック
            a = 1; r = 0; g = 0; b = 0
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}