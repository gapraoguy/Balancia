import Foundation

struct FormatterUtils {
    static func formattedAmount(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }

    static func formattedAmountWithSymbol(_ value: Int) -> String {
        "¥" + formattedAmount(value)
    }
}
