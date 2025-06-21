import SwiftUI

struct DailySummary {
    var income: Int = 0
    var expense: Int = 0
}

extension Date {
    func startOfMonth(using calendar: Calendar = .current) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
    }

    func daysInMonth(using calendar: Calendar = .current) -> [Date] {
        let start = startOfMonth()
        let range = calendar.range(of: .day, in: .month, for: start)!
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: start)
        }
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    let entries: [EntryModel]

    private let calendar = Calendar.current
    private let daysOfWeek = ["日", "月", "火", "水", "木", "金", "土"]

    private var days: [Date] {
        let startOfMonth = selectedDate.startOfMonth()
        let daysInMonth = startOfMonth.daysInMonth()
        let firstWeekday = calendar.component(.weekday, from: daysInMonth.first!) - 1
        return Array(repeating: Date.distantPast, count: firstWeekday) + daysInMonth
    }

    private var dailySummaries: [Date: DailySummary] {
        var summaries: [Date: DailySummary] = [:]
        for entry in entries {
            let day = calendar.startOfDay(for: entry.date)
            if summaries[day] == nil {
                summaries[day] = DailySummary()
            }
            if entry.type == .income {
                summaries[day]?.income += entry.amount
            } else {
                summaries[day]?.expense += entry.amount
            }
        }
        return summaries
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(days.enumerated()), id: \.offset) { _, date in
                    if calendar.isDate(date, equalTo: Date.distantPast, toGranularity: .day) {
                        Color.clear.frame(height: 48)
                    } else {
                        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                        let summary = dailySummaries[calendar.startOfDay(for: date)]

                        VStack(spacing: 2) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.footnote)
                                .foregroundColor(isSelected ? .white : .primary)
                                .padding(8)
                                .background(
                                    isSelected
                                        ? Circle().fill(Color.accentColor)
                                        : nil
                                )

                            if let summary = summary {
                                Text(summary.income > 0 ? FormatterUtils.formattedAmountWithSymbol(summary.income) : " ")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                                Text(summary.expense > 0 ? FormatterUtils.formattedAmountWithSymbol(summary.expense) : " ")
                                    .font(.caption2)
                                    .foregroundColor(.red)
                            } else {
                                Text(" ").font(.caption2)
                                Text(" ").font(.caption2)
                            }
                        }
                        .frame(height: 60)
                        .onTapGesture {
                            selectedDate = date
                        }
                    }
                }
            }
        }
    }
}
