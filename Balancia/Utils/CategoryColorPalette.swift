struct CategoryColorPalette {
    static let allColors: [String] = [
        "FFB6B6", "A0E7E5", "FFDAC1", "E2F0CB",
        "B5EAD7", "C7CEEA", "FFD6A5", "FF9AA2",
        "D5AAFF", "A2CFFE", "FFABAB", "E6E6FA"
    ]

    static func availableColors(used: [String]) -> [String] {
        allColors.filter { !used.contains($0) }
    }
}