import Foundation
import RealmSwift

class EntryRepository: EntryRepositoryProtocol {
    private let realm = try! Realm()

    func create(_ entry: EntryModel) {
        try? realm.write {
            let realmEntry = RealmEntry(from: entry, in: realm)
            realm.add(realmEntry)
        }
    }

    func update(_ entry: EntryModel) {
        try? realm.write {
            let realmEntry = RealmEntry(from: entry, in: realm)
            realm.add(realmEntry, update: .modified)
        }
    }

    func delete(_ entry: EntryModel) {
        guard let realmEntry = realm.object(ofType: RealmEntry.self, forPrimaryKey: entry.id) else { return }
        try? realm.write {
            realm.delete(realmEntry)
        }
    }

    func getAll() -> [EntryModel] {
        let results = realm.objects(RealmEntry.self)
            .sorted(byKeyPath: "date", ascending: false)
        return results.map { $0.toModel() }
    }

    func get(forMonth date: Date) -> [EntryModel] {
        let calendar = Calendar.current
        guard let start = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let end = calendar.date(byAdding: .month, value: 1, to: start)
        else {
            return []
        }

        let results = realm.objects(RealmEntry.self)
            .filter("date >= %@ AND date < %@", start, end)
            .sorted(byKeyPath: "date", ascending: false)

        return results.map { $0.toModel() }
    }
}
