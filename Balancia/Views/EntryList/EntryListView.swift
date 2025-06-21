import SwiftUI

struct EntryListView: View {
    @EnvironmentObject var viewModel: EntryListViewModel
    @EnvironmentObject var entryFormViewModel: EntryFormViewModel

    @State private var isShowingSheet = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
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
                                EntryRowView(entry: entry)
                                    .onTapGesture {
                                        entryFormViewModel.setEntry(entry)
                                        isShowingSheet = true
                                    }
                            }
                            .onDelete(perform: viewModel.deleteEntry)
                        }
                        .listStyle(.plain)
                    }
                }

                Button(action: {
                    entryFormViewModel.reset()
                    isShowingSheet = true
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
            }
            .sheet(isPresented: $isShowingSheet, onDismiss: {
                entryFormViewModel.reset()
            }) {
                EntryFormView()
            }
            .onDisappear {
                entryFormViewModel.reset()
            }
        }
    }

    private struct EntryRowView: View {
        let entry: EntryModel

        var body: some View {
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
        }
    }

    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 M月"
        return formatter
    }
}
