import Foundation
import SwiftUI

class CategoryManagementViewModel: ObservableObject {
    @Published var incomeCategories: [CategoryModel] = []
    @Published var expenseCategories: [CategoryModel] = []
    @Published var selectedType: EntryType = .expense
    @Published var showingCategoryDialog: Bool = false
    @Published var categoryName: String = ""
    @Published var editingCategory: CategoryModel? = nil
    @Published var focusedField: CategoryFocusField? = nil
    @Published var categoryUpdated: Bool = false
    @Published var allColors: [CategoryColorModel] = []
    @Published var selectedColorHex: String = ""

    private let categoryRepository: CategoryRepositoryProtocol
    private let colorRepository: CategoryColorRepositoryProtocol

    init(
        categoryRepository: CategoryRepositoryProtocol = CategoryRepository(),
        colorRepository: CategoryColorRepositoryProtocol = CategoryColorRepository()
    ) {
        self.categoryRepository = categoryRepository
        self.colorRepository = colorRepository
        loadCategories()
        loadColors()
    }

    func loadCategories() {
        let all = categoryRepository.getAll()
        self.incomeCategories = all.filter { $0.type == .income }
        self.expenseCategories = all.filter { $0.type == .expense }
    }

    func loadColors() {
        self.allColors = colorRepository.getAll()
    }

    func prepareForNewCategory() {
        categoryName = ""
        selectedType = .expense
        selectedColorHex = ""
        editingCategory = nil
        showingCategoryDialog = true
    }

    func prepareForEdit(_ category: CategoryModel) {
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
                var updated = editing
                let oldHex = editing.color?.hex
                let newHex = selectedColorHex

                if oldHex != newHex {
                    if let oldHex = oldHex {
                        colorRepository.releaseColor(oldHex)
                    }
                    try colorRepository.reserveColor(newHex)
                    updated.color = colorRepository.get(byHex: newHex)
                }

                updated.name = trimmedName
                updated.type = selectedType

                categoryRepository.update(updated)
            } else {
                try colorRepository.reserveColor(selectedColorHex)

                let newCategory = CategoryModel(
                    name: trimmedName,
                    type: selectedType,
                    color: colorRepository.get(byHex: selectedColorHex)
                )

                categoryRepository.create(newCategory)
            }

            categoryName = ""
            showingCategoryDialog = false
            loadCategories()
            categoryUpdated = true

        } catch {
            print("カテゴリ保存に失敗: \(error.localizedDescription)")
        }
    }

    func deleteCategory(at offsets: IndexSet, for type: EntryType) {
        let categories = (type == .income) ? incomeCategories : expenseCategories
        offsets.forEach { index in
            let categoryToDelete = categories[index]
            if let hex = categoryToDelete.color?.hex {
                colorRepository.releaseColor(hex)
            }
            categoryRepository.delete(categoryToDelete)
            loadCategories()
            categoryUpdated = true
        }
    }

    var availableColors: [String] {
        colorRepository.getAvailable().map { $0.hex }
    }

    func isColorUsed(_ colorHex: String) -> Bool {
        colorRepository.isColorUsed(colorHex, excluding: editingCategory)
    }
}
