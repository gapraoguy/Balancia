import Foundation
import RealmSwift

class CategoryService: CategoryServiceProtocol {
    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    func createCategory(name: String, type: EntryType, colorHex: String) throws {
        guard let color = realm.object(ofType: CategoryColor.self, forPrimaryKey: colorHex), !color.isUsed else {
            throw CategoryServiceError.colorAlreadyUsed
        }

        let category = Category()
        category.name = name
        category.type = type
        category.color = color

        try realm.write {
            color.isUsed = true
            realm.add(category)
        }
    }

    func updateCategory(category: Category, newName: String, newType: EntryType, newColorHex: String) throws {
        guard let newColor = realm.object(ofType: CategoryColor.self, forPrimaryKey: newColorHex) else {
            throw CategoryServiceError.invalidColor
        }

        try realm.write {
            // 元の色を開放（必要な場合）
            if let oldColor = category.color, oldColor.hex != newColorHex {
                oldColor.isUsed = false
            }

            category.name = newName
            category.type = newType
            category.color = newColor
            newColor.isUsed = true
        }
    }

    func deleteCategory(_ category: Category) throws {
        try realm.write {
            if let color = category.color {
                color.isUsed = false
            }
            realm.delete(category)
        }
    }

    func getAllCategories() -> [Category] {
        return Array(realm.objects(Category.self).sorted(byKeyPath: "name"))
    }
}

enum CategoryServiceError: Error {
    case colorAlreadyUsed
    case invalidColor
}
