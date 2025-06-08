import SwiftUI

enum FocusField: Hashable {
    case amount
    case memo
}

struct EntryFormView: View {
    @EnvironmentObject var listViewModel: EntryListViewModel
    
    @StateObject private var viewModel = EntryFormViewModel()
    
    @FocusState private var focusedField: FocusField?
    
    init(entry: Entry? = nil) {
        _viewModel = StateObject(wrappedValue: EntryFormViewModel(entry: entry))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("金額")) {
                    TextField("¥0", text: $viewModel.amount)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .amount)
                }

                Section(header: Text("日付")) {
                    DatePicker("日付", selection: $viewModel.date, displayedComponents: .date)
                }

                Section(header: Text("タイプ")) {
                    Picker("タイプ", selection: $viewModel.selectedType) {
                        ForEach(EntryType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: viewModel.selectedType) {
                        viewModel.onTypeChanged()
                    }
                }

                Section(header: Text("カテゴリ")) {
                    Picker("カテゴリ", selection: $viewModel.selectedCategory) {
                        Text("選択してください").tag(Category?.none)
                        ForEach(viewModel.filteredCategories, id: \.id) { category in
                            Text(category.name).tag(Optional(category))
                        }
                    }
                }

                Section(header: Text("メモ")) {
                    TextField("任意", text: $viewModel.memo)
                        .focused($focusedField, equals: .memo)
                }

                Section {
                    Button("保存") {
                        viewModel.saveEntry()
                    }
                }
            }
            .navigationTitle("記録を追加")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("完了") {
                        focusedField = nil
                    }
                }
            }
        }
        .alert("保存しました", isPresented: $viewModel.saved) {
            Button("OK", role: .cancel) {
                listViewModel.loadEntries()
                viewModel.amount = ""
                viewModel.memo = ""
                viewModel.date = Date()
                viewModel.selectedCategory = nil
                viewModel.selectedType = .expense
            }
        }

    }
}

