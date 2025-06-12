struct CategoryColorPalette {
    /// iOS システムカラーに近い 12 色パレット
    /// - systemRed:    #FF3B30
    /// - systemOrange: #FF9500
    /// - systemYellow: #FFD60A
    /// - systemGreen:  #34C759
    /// - systemMint:   #32D74B
    /// - systemTeal:   #5AC8FA
    /// - systemCyan:   #64D2FF
    /// - systemBlue:   #0A84FF
    /// - systemIndigo: #5856D6
    /// - systemPurple: #AF52DE
    /// - systemPink:   #FF2D55
    /// - systemGray:   #8E8E93
    static let allColors: [String] = [
        "FF3B30",  // systemRed
        "FF9500",  // systemOrange
        "FFD60A",  // systemYellow
        "34C759",  // systemGreen
        "32D74B",  // systemMint
        "5AC8FA",  // systemTeal
        "64D2FF",  // systemCyan
        "0A84FF",  // systemBlue
        "5856D6",  // systemIndigo
        "AF52DE",  // systemPurple
        "FF2D55",  // systemPink
        "8E8E93"   // systemGray
    ]

    static func availableColors(used: [String]) -> [String] {
        allColors.filter { !used.contains($0) }
    }
}
