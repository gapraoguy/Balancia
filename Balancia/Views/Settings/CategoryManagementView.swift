import SwiftUI

enum CategoryFocusField: Hashable {
    case categoryName
}

struct CategoryManagementView: View {
    @StateObject private var viewModel = CategoryManagementViewModel()
    @State private var editingCategory: Category? = nil
    
    var body: some View {
        NavigationStack {
            List {
                categorySection(title: "収入カテゴリ", categories: viewModel.incomeCategories, type: .income)
                categorySection(title: "支出カテゴリ", categories: viewModel.expenseCategories, type: .expense)

                Button("＋ 新規追加") {
                    viewModel.prepareForNewCategory()
                }
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("完了") {
                        viewModel.focusedField = nil
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingCategoryDialog) {
                CategoryInputSheet(viewModel: viewModel)
            }
            .navigationTitle("カテゴリ管理")
        }
    }

    @ViewBuilder
    private func categorySection(title: String, categories: [Category], type: EntryType) -> some View {
        Section(header: Text(title)) {
            ForEach(categories, id: \.id) { category in
                Text(category.name)
                    .onTapGesture {
                        viewModel.prepareForEdit(category)
                    }
            }
            .onDelete { indexSet in
                viewModel.deleteCategory(at: indexSet, for: type)
            }
        }
    }
}
