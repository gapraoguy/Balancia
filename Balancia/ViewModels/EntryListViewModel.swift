import Foundation

@MainActor
class EntryListViewModel: ObservableObject {
    @Published var entries: [EntryModel] = []
    @Published var selectedDate: Date = Date()

    private let repository: EntryRepositoryProtocol

    init(repository: EntryRepositoryProtocol = EntryRepository()) {
        self.repository = repository
        loadEntries()
    }

    func loadEntries() {
        self.entries = repository.getAll().sorted(by: { $0.date > $1.date })
        print("loadEntries: \(entries.count) 件読み込み")
    }

    func deleteEntry(at offsets: IndexSet) {
        for index in offsets {
            let entryToDelete = entries[index]
            repository.delete(entryToDelete)
        }
        loadEntries()
    }

    var filteredEntries: [EntryModel] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }

    func moveMonth(by offset: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: offset, to: selectedDate) {
            selectedDate = newDate
        }
    }
}
