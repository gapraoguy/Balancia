import Foundation

protocol EntryRepositoryProtocol {
    func create(_ entry: EntryModel)
    func update(_ entry: EntryModel)
    func delete(_ entry: EntryModel)
    func getAll() -> [EntryModel]
    func get(forMonth date: Date) -> [EntryModel]
}
