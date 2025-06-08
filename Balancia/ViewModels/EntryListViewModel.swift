import Foundation
import RealmSwift

@MainActor
class EntryListViewModel: ObservableObject {
    @Published var entries: [Entry] = []
    @Published var selectedDate: Date = Date()

    private var realm: Realm

    init() {
        self.realm = try! Realm()
        loadEntries()
    }

    func loadEntries() {
        let results = realm.objects(Entry.self).sorted(byKeyPath: "date", ascending: false)
        self.entries = Array(results)
        print("loadEntries: \(entries.count) 件読み込み")
    }
    
    func deleteEntry(at offsets: IndexSet) {
        for index in offsets {
            let entryToDelete = entries[index]
            try? realm.write {
                realm.delete(entryToDelete)
            }
        }
        loadEntries()
    }
    
    var filteredEntries: [Entry] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    func moveMonth(by offset: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: offset, to: selectedDate) {
            selectedDate = newDate
        }
    }
}
