import Foundation
import RealmSwift

class CategoryColorService: CategoryColorServiceProtocol {
    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    func getAllColors() -> [CategoryColor] {
        return Array(realm.objects(CategoryColor.self).sorted(byKeyPath: "hex"))
    }

    func getAvailableColors() -> [CategoryColor] {
        return realm.objects(CategoryColor.self)
            .filter("isUsed == false")
            .sorted(byKeyPath: "hex")
            .map { $0 }
    }

    func isColorUsed(_ hex: String, excluding category: Category?) -> Bool {
        guard let color = realm.object(ofType: CategoryColor.self, forPrimaryKey: hex) else {
            return false
        }
        return color.isUsed && color.hex != category?.color?.hex
    }

    func reserveColor(_ hex: String) throws {
        guard let color = realm.object(ofType: CategoryColor.self, forPrimaryKey: hex) else { return }
        if color.isUsed { throw ColorAlreadyUsedError() }

        try realm.write {
            color.isUsed = true
        }
    }

    func releaseColor(_ hex: String) {
        guard let color = realm.object(ofType: CategoryColor.self, forPrimaryKey: hex) else { return }
        try? realm.write {
            color.isUsed = false
        }
    }
}

struct ColorAlreadyUsedError: Error {}
