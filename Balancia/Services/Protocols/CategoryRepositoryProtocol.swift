import Foundation
import RealmSwift

protocol CategoryRepositoryProtocol {
    func getAll() -> [CategoryModel]
    func get(by type: EntryType) -> [CategoryModel]
    func create(_ model: CategoryModel)
    func update(_ model: CategoryModel)
    func delete(_ model: CategoryModel)
    func get(byId id: ObjectId) -> CategoryModel?
}
