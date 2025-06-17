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
    
    private let categoryService: CategoryServiceProtocol
    private let colorService: CategoryColorServiceProtocol

    init(
        categoryService: CategoryServiceProtocol = CategoryService(),
        colorService: CategoryColorServiceProtocol = CategoryColorService()
    ) {
        self.categoryService = categoryService
        self.colorService = colorService
        loadCategories()
        loadColors()
    }

    func loadCategories() {
        let all = categoryService.getAllCategories()
        self.incomeCategories = all.filter { $0.type == .income }
        self.expenseCategories = all.filter { $0.type == .expense }
    }
    
    func loadColors() {
        self.allColors = colorService.getAllColors()
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
            if let editing = editingCategory {
                
                if let oldColorHex = editing.color?.hex,
                   oldColorHex != selectedColorHex {
                    colorService.releaseColor(oldColorHex)
                }

                try colorService.reserveColor(selectedColorHex)

                try categoryService.updateCategory(
                    category: editing,
                    newName: trimmedName,
                    newType: selectedType,
                    newColorHex: selectedColorHex
                )
            } else {
                try colorService.reserveColor(selectedColorHex)
                
                try categoryService.createCategory(
                    name: trimmedName,
                    type: selectedType,
                    colorHex: selectedColorHex
                )
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
                try categoryService.deleteCategory(categoryToDelete)
                loadCategories()
                print("update")
                categoryUpdated = true
            } catch {
                print("カテゴリ削除に失敗: \(error.localizedDescription)")
            }
        }
    }

    var availableColors: [String] {
        colorService.getAvailableColors().map { $0.hex }
    }
    
    func isColorUsed(_ colorHex: String) -> Bool {
        colorService.isColorUsed(colorHex, excluding: editingCategory)
    }
}
