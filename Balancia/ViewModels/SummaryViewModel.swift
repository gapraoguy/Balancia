import Foundation

struct CategorySummary: Identifiable {
    let id = UUID()
    let categoryName: String
    let amount: Int
    let colorHex: String
}

@MainActor
class SummaryViewModel: ObservableObject {
    @Published var selectedMonth: Date = Date()
    @Published var totalIncome: Int = 0
    @Published var totalExpense: Int = 0
    @Published var categorySummaries: [CategorySummary] = []

    var netBalance: Int {
        totalIncome - totalExpense
    }

    var formattedTotalIncome: String {
        FormatterUtils.formattedAmountWithSymbol(totalIncome)
    }

    var formattedTotalExpense: String {
        FormatterUtils.formattedAmountWithSymbol(totalExpense)
    }

    var formattedNetBalance: String {
        FormatterUtils.formattedAmountWithSymbol(netBalance)
    }

    var formattedMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月"
        return formatter.string(from: selectedMonth)
    }

    func moveMonth(by offset: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: offset, to: selectedMonth) {
            selectedMonth = newDate
        }
    }

    func calculate(from entries: [EntryModel]) {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedMonth))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!

        let monthEntries = entries.filter { $0.date >= startOfMonth && $0.date < endOfMonth }

        totalIncome = monthEntries.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        totalExpense = monthEntries.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }

        let grouped = Dictionary(grouping: monthEntries.filter { $0.type == .expense }) {
            $0.category?.id
        }

        categorySummaries = grouped.compactMap { (id, entries) in
            guard let category = entries.first?.category else { return nil }
            let total = entries.reduce(0) { $0 + $1.amount }
            print(total)
            return CategorySummary(
                categoryName: category.name,
                amount: total,
                colorHex: category.color?.hex ?? "#D3D3D3"
            )
        }
    }
}
