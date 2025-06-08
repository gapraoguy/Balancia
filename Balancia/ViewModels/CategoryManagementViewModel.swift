import Foundation
import SwiftUI
import RealmSwift

class CategoryManagementViewModel: ObservableObject {
    @Published var incomeCategories: [Category] = []
    @Published var expenseCategories: [Category] = []
    @Published var selectedType: EntryType = .expense
    
    @Published var showingCategoryDialog: Bool = false
    @Published var categoryName: String = ""
    
    @Published var focusedField: CategoryFocusField? = nil

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

        func addNewCategory() {
            let trimmedName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedName.isEmpty else { return }
    
            let category = Category()
            category.name = trimmedName
            category.type = selectedType
    
            do {
                try realm.write {
                    realm.add(category)
                }
                categoryName = ""
                showingCategoryDialog = false
                loadCategories()
            } catch {
                print("カテゴリ追加に失敗: \(error.localizedDescription)")
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
            } catch {
                print("カテゴリ削除に失敗: \(error.localizedDescription)")
            }
        }
    }
}
