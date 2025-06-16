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
    @Published var allColors: [CategoryColor] = []
    @Published var selectedColorHex: String = ""

    private var realm: Realm

    init() {
        self.realm = try! Realm()
        loadCategories()
        loadColors()
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
    
    func loadColors() {
        let objects = realm.objects(CategoryColor.self).sorted(byKeyPath: "hex")
        self.allColors = Array(objects)
    }

    func prepareForNewCategory() {
        categoryName = ""
        selectedType = .expense
        selectedColorHex = ""
        editingCategory = nil
        showingCategoryDialog = true
    }

    func prepareForEdit(_ category: Category) {
        categoryName = category.name
        selectedType = category.type
        selectedColorHex = category.color?.hex ?? ""
        editingCategory = category
        showingCategoryDialog = true
    }

    func saveCategory() {
        let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        do {
            try realm.write {
                guard let selectedColor = realm.object(ofType: CategoryColor.self, forPrimaryKey: selectedColorHex) else {
                    print("色が選択されていません")
                    return
                }

                if let editing = editingCategory {
                    if let oldColor = editing.color, oldColor.hex != selectedColorHex {
                        oldColor.isUsed = false
                    }

                    editing.name = trimmedName
                    editing.type = selectedType
                    editing.color = selectedColor
                    selectedColor.isUsed = true
                } else {
                    let category = Category()
                    category.name = trimmedName
                    category.type = selectedType
                    category.color = selectedColor
                    selectedColor.isUsed = true
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
                    if let color = categoryToDelete.color {
                        color.isUsed = false
                    }
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
        let available = realm.objects(CategoryColor.self)
            .filter("isUsed == false")
            .sorted(byKeyPath: "hex")
        return available.map { $0.hex }
    }
    
    func isColorUsed(_ colorHex: String) -> Bool {
        guard let color = allColors.first(where: { $0.hex == colorHex }) else { return false }
        let isEditingSameColor = (editingCategory?.color?.hex == colorHex)
        return color.isUsed && !isEditingSameColor
    }
}
