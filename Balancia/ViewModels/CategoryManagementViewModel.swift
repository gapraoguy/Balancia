import Foundation
import SwiftUI
import RealmSwift

class CategoryManagementViewModel: ObservableObject {
    @Published var incomeCategories: [Category] = []
    @Published var expenseCategories: [Category] = []
    @Published var selectedType: EntryType = .expense
    @Published var showingCategoryDialog: Bool = false
    @Published var categoryName: String = ""
    @Published var editingCategory: Category? = nil
    @Published var focusedField: CategoryFocusField? = nil
    @Published var categoryUpdated: Bool = false

    private var realm: Realm

    init() {
        self.realm = try! Realm()
        loadCategories()
    }

    func loadCategories() {
        let income = realm.objects(Category.self)
            .filter("type == %@", EntryType.income.rawValue)
            .sorted(byKeyPath: "name")

        let expense = realm.objects(Category.self)
            .filter("type == %@", EntryType.expense.rawValue)
            .sorted(byKeyPath: "name")

        self.incomeCategories = Array(income)
        self.expenseCategories = Array(expense)
    }

    func prepareForNewCategory() {
        categoryName = ""
        selectedType = .expense
        editingCategory = nil
        showingCategoryDialog = true
    }

    func prepareForEdit(_ category: Category) {
        categoryName = category.name
        selectedType = category.type
        editingCategory = category
        showingCategoryDialog = true
    }

    func saveCategory() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        do {
            try realm.write {
                if let editing = editingCategory {
                    editing.name = trimmedName
                    editing.type = selectedType
                } else {
                    let category = Category()
                    category.name = trimmedName
                    category.type = selectedType
                    realm.add(category)
                }
            }
            categoryName = ""
            showingCategoryDialog = false
            loadCategories()
            print("update")
            categoryUpdated = true
        } catch {
            print("カテゴリ保存に失敗: \(error.localizedDescription)")
        }
    }

    func deleteCategory(at offsets: IndexSet, for type: EntryType) {
        let categories = (type == .income) ? incomeCategories : expenseCategories
        offsets.forEach { index in
            let categoryToDelete = categories[index]
            do {
                try realm.write {
                    realm.delete(categoryToDelete)
                }
                loadCategories()
                print("update")
                categoryUpdated = true
            } catch {
                print("カテゴリ削除に失敗: \(error.localizedDescription)")
            }
        }
    }
    
    var availableColors: [String] {
        let used = (incomeCategories + expenseCategories).map { $0.colorHex }
        return CategoryColorPalette.availableColors(used: used)
    }
}
