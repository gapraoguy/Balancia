import Foundation
import RealmSwift

class CategoryRepository: CategoryRepositoryProtocol {
    private let realm = try! Realm()

    func getAll() -> [CategoryModel] {
        realm.objects(RealmCategory.self)
            .map { $0.toModel() }
    }

    func get(by type: EntryType) -> [CategoryModel] {
        realm.objects(RealmCategory.self)
            .filter("type == %@", type.rawValue)
            .sorted(byKeyPath: "name")
            .map { $0.toModel() }
    }

    func get(byId id: ObjectId) -> CategoryModel? {
        guard let object = realm.object(ofType: RealmCategory.self, forPrimaryKey: id) else { return nil }
        return object.toModel()
    }

    func create(_ model: CategoryModel) {
        try? realm.write {
            let realmCategory = RealmCategory(from: model, in: realm)
            realm.add(realmCategory)
        }
    }

    func update(_ model: CategoryModel) {
        try? realm.write {
            let realmCategory = RealmCategory(from: model, in: realm)
            realm.add(realmCategory, update: .modified)
        }
    }

    func delete(_ model: CategoryModel) {
        guard let object = realm.object(ofType: RealmCategory.self, forPrimaryKey: model.id) else { return }
        try? realm.write {
            realm.delete(object)
        }
    }
}
