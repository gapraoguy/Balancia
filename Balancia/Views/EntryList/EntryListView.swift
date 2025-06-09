import SwiftUI

struct EntryListView: View {
    @EnvironmentObject var viewModel: EntryListViewModel
    @State private var selectedEntry: Entry?

    var body: some View {
        NavigationStack {
            VStack {
                MonthSelectorView(
                    dateText: monthFormatter.string(from: viewModel.selectedDate),
                    onPrevious: { viewModel.moveMonth(by: -1) },
                    onNext: { viewModel.moveMonth(by: 1) }
                )
                
                CalendarView(selectedDate: $viewModel.selectedDate, entries: viewModel.entries)

                Divider()

                if viewModel.filteredEntries.isEmpty {
                    Text("この日の記録はありません")
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.filteredEntries, id: \.id) { entry in
                            HStack {
                                Text(entry.category?.name ?? "カテゴリなし")
                                    .font(.body)

                                if let memo = entry.memo, !memo.isEmpty {
                                    Text(memo)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Text(FormatterUtils.formattedAmountWithSymbol(entry.amount))
                                    .foregroundColor(entry.type == .expense ? .red : .green)
                            }
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedEntry = entry
                            }
                        }
                        .onDelete(perform: viewModel.deleteEntry)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationDestination(item: $selectedEntry) { entry in
                EntryFormView()
                    .environmentObject(EntryFormViewModel(entry: entry))
            }
        }
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月"
        return formatter
    }
}
