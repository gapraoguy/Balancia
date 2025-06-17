import Foundation

protocol EntryRepositoryProtocol {
    func save(_ entry: EntryModel)
    func delete(_ entry: EntryModel)
    func getAll() -> [EntryModel]
    func get(forMonth date: Date) -> [EntryModel]
}
