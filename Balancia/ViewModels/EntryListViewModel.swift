import Foundation
import RealmSwift

@MainActor
class EntryListViewModel: ObservableObject {
    @Published var entries: [Entry] = []

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
    
    
}
