import SwiftUI
import RealmSwift

struct CategoryManagementView: View {
    @ObservedResults(Category.self, sortDescriptor: SortDescriptor(keyPath: "name")) var categories

    @State private var newCategoryName = ""
    @State private var selectedType: EntryType = .expense

    var body: some View {
        VStack {
            Form {
                Section(header: Text("新しいカテゴリを追加")) {
                    TextField("カテゴリ名", text: $newCategoryName)
                    Picker("タイプ", selection: $selectedType) {
                        ForEach(EntryType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                    Button("追加") {
                        addCategory()
                    }
                    .disabled(newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                Section(header: Text("既存のカテゴリ")) {
                    List {
                        ForEach(categories) { category in
                            HStack {
                                Text(category.name)
                                Spacer()
                                Text(category.type.localizedName)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete(perform: deleteCategory)
                    }
                }
            }
        }
        .navigationTitle("カテゴリ管理")
    }

    private func addCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        let newCategory = Category()
        newCategory.name = trimmedName
        newCategory.type = selectedType

        $categories.append(newCategory)
        newCategoryName = ""
    }

    private func deleteCategory(at offsets: IndexSet) {
        for index in offsets {
            let category = categories[index]
            guard let realm = category.realm else { continue }
            try? realm.write {
                realm.delete(category)
            }
        }
    }
}