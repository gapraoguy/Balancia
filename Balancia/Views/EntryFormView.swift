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
            VStack {
                HStack(spacing: 16) {
                    Text("記録入力")
                        .font(.headline)
                }
                Form {
                    Section(header: Text("金額")) {
                        TextField("¥0", text: $viewModel.amount)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .amount)
                    }

                    Section {
                        DatePicker("日付", selection: $viewModel.date, displayedComponents: .date)
                    }

                    Section {
                        Picker("", selection: $viewModel.selectedType) {
                            ForEach(EntryType.allCases, id: \.self) { type in
                                Text(type.displayName)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: viewModel.selectedType) {
                            viewModel.onTypeChanged()
                        }
                    }

                    Section {
                        Picker("カテゴリ", selection: $viewModel.selectedCategory) {
                            Text("選択してください").tag(Category?.none)
                            ForEach(viewModel.filteredCategories, id: \.id) { category in
                                Text(category.name).tag(Optional(category))
                            }
                        }
                    }

                    Section {
                        TextField("メモ", text: $viewModel.memo)
                            .focused($focusedField, equals: .memo)
                    }
                    
                    Section {
                        Button(action: {
                            viewModel.saveEntry()
                        }) {
                            HStack {
                                Spacer()
                                Label("保存", systemImage: "checkmark.circle.fill")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(viewModel.amount.isEmpty || Int(viewModel.amount) == 0 ? Color.gray : Color.accentColor)
                            .cornerRadius(10)
                        }
                        .disabled(viewModel.amount.isEmpty || Int(viewModel.amount) == 0)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("完了") {
                        focusedField = nil
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
}
