import SwiftUI

enum CategoryFocusField: Hashable {
    case categoryName
}

struct CategoryManagementView: View {
    @ObservedObject var viewModel: CategoryManagementViewModel
    @State private var editingCategory: CategoryModel? = nil

    var body: some View {
        NavigationStack {
            List {
                categorySection(title: "収入カテゴリ", categories: viewModel.incomeCategories, type: .income)
                categorySection(title: "支出カテゴリ", categories: viewModel.expenseCategories, type: .expense)

                Section {
                    Button(action: {
                        viewModel.prepareForNewCategory()
                    }) {
                        HStack {
                            Spacer()
                            Label("新規追加", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .sheet(isPresented: $viewModel.showingCategoryDialog) {
                CategoryInputSheet(viewModel: viewModel)
            }
        }
    }

    @ViewBuilder
    private func categorySection(title: String, categories: [CategoryModel], type: EntryType) -> some View {
        Section(header: Text(title)) {
            ForEach(categories, id: \.id) { category in
                HStack {
                    Circle()
                        .fill(Color.hex(category.color?.hex ?? "#D3D3D3"))
                        .frame(width: 16, height: 16)

                    Text(category.name)
                        .padding(.leading, 4)

                    Spacer()
                }
                .contentShape(Rectangle())
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
