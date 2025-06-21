import Foundation
import RealmSwift

class CategoryColorRepository: CategoryColorRepositoryProtocol {
    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    func getAll() -> [CategoryColorModel] {
        realm.objects(RealmCategoryColor.self)
            .sorted(byKeyPath: "hex")
            .map { $0.toModel() }
    }

    func getAvailable() -> [CategoryColorModel] {
        realm.objects(RealmCategoryColor.self)
            .filter("isUsed == false")
            .sorted(byKeyPath: "hex")
            .map { $0.toModel() }
    }

    func get(byHex hex: String) -> CategoryColorModel? {
        realm.object(ofType: RealmCategoryColor.self, forPrimaryKey: hex)?.toModel()
    }

    func isColorUsed(_ hex: String, excluding category: CategoryModel?) -> Bool {
        guard let color = realm.object(ofType: RealmCategoryColor.self, forPrimaryKey: hex) else {
            return false
        }
        return color.isUsed && color.hex != category?.color?.hex
    }

    func reserveColor(_ hex: String) throws {
        guard let color = realm.object(ofType: RealmCategoryColor.self, forPrimaryKey: hex) else { return }
        if color.isUsed {
            throw ColorAlreadyUsedError()
        }
        try realm.write {
            color.isUsed = true
        }
    }

    func releaseColor(_ hex: String) {
        guard let color = realm.object(ofType: RealmCategoryColor.self, forPrimaryKey: hex) else { return }
        try? realm.write {
            color.isUsed = false
        }
    }

    func save(_ color: CategoryColorModel) {
        guard get(byHex: color.hex) == nil else { return }

        let realmColor = RealmCategoryColor()
        realmColor.hex = color.hex
        realmColor.isUsed = color.isUsed

        try? realm.write {
            realm.add(realmColor, update: .modified)
        }
    }
}

struct ColorAlreadyUsedError: Error {}
