import Foundation
import RealmSwift

class CategoryManagementViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var newCategoryName: String = ""
    @Published var selectedType: EntryType = .expense

    private var realm: Realm

    init() {
        realm = try! Realm()
        loadCategories()
    }

    func loadCategories() {
        let results = realm.objects(Category.self)
            .filter("type == %@", selectedType.rawValue)
            .sorted(byKeyPath: "name")
        categories = Array(results)
    }

    func addCategory() {
        guard !newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let category = Category()
        category.name = newCategoryName
        category.type = selectedType

        do {
            try realm.write {
                realm.add(category)
            }
            newCategoryName = ""
            loadCategories()
        } catch {
            print("カテゴリ追加エラー: \(error.localizedDescription)")
        }
    }

    func deleteCategory(at offsets: IndexSet) {
        for index in offsets {
            let category = categories[index]
            try? realm.write {
                realm.delete(category)
            }
        }
        loadCategories()
    }
}