import SwiftUI

struct EntryListView: View {
    @EnvironmentObject var viewModel: EntryListViewModel
    
    @State private var selectedEntry: Entry?
    @State private var isEditing = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.entries, id: \.id) { entry in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.category?.name ?? "カテゴリなし")
                                .font(.headline)

                            if let memo = entry.memo, !memo.isEmpty {
                                Text(memo)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Text(entry.date, style: .date)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Text(FormatterUtils.formattedAmountWithSymbol(entry.amount))
                            .font(.body)
                            .foregroundColor(entry.type == .expense ? .red : .green)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedEntry = entry
                        isEditing = true
                    }
                }
                .onDelete(perform: viewModel.deleteEntry)
            }
            .navigationTitle("履歴")
            .navigationDestination(item: $selectedEntry) { entry in
                EntryFormView(entry: entry)
                    .environmentObject(viewModel)
            }
        }
    }
}
