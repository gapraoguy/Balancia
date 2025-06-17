import Foundation
import RealmSwift

protocol CategoryServiceProtocol {
    func createCategory(name: String, type: EntryType, colorHex: String) throws
    func updateCategory(category: Category, newName: String, newType: EntryType, newColorHex: String) throws
    func deleteCategory(_ category: Category) throws
    func getAllCategories() -> [Category]
}
