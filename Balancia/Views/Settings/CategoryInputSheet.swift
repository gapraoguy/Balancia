import SwiftUI
import RealmSwift

struct CategoryInputSheet: View {
    @ObservedObject var viewModel: CategoryManagementViewModel
    @FocusState private var focusedField: CategoryFocusField?

    var body: some View {
        VStack(spacing: 24) {
            TitleSection()
            TypePickerSection(selectedType: $viewModel.selectedType)
            NameInputSection(categoryName: $viewModel.categoryName, focusedField: $focusedField)
            Divider()
            ButtonSection(viewModel: viewModel)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
        )
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("完了") {
                    viewModel.focusedField = nil
                }
            }
        }
        .onChange(of: viewModel.focusedField) { focusedField = $0 }
        .onChange(of: focusedField) { viewModel.focusedField = $0 }
    }
    
    private struct TitleSection: View {
        var body: some View {
            Text("カテゴリを追加")
                .font(.title2)
                .bold()
        }
    }
    
    private struct TypePickerSection: View {
        @Binding var selectedType: EntryType

        var body: some View {
            Picker("タイプ", selection: $selectedType) {
                ForEach(EntryType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
        }
    }
    
    private struct NameInputSection: View {
        @Binding var categoryName: String
        @FocusState.Binding var focusedField: CategoryFocusField?

        var body: some View {
            TextField("カテゴリ名", text: $categoryName)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .padding(.horizontal)
                .focused($focusedField, equals: .categoryName)
        }
    }
    
    private struct ButtonSection: View {
        @ObservedObject var viewModel: CategoryManagementViewModel

        var body: some View {
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.saveCategory()
                }) {
                    HStack {
                        Spacer()
                        Label("保存", systemImage: "checkmark.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
                }
                .disabled(viewModel.categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Button("キャンセル", role: .cancel) {
                    viewModel.showingCategoryDialog = false
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
    }
}
