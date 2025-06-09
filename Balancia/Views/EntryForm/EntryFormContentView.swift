import SwiftUI

enum FocusField: Hashable {
    case amount
    case memo
}

struct EntryFormContentView: View {
    @ObservedObject var viewModel: EntryFormViewModel
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        Form {
            Section(header: Text("金額")) {
                TextField("¥0", text: $viewModel.amount)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .amount)
            }
            
            Section {
                DatePicker("日付", selection: $viewModel.date, displayedComponents: .date)
            }
            
            Section(header: Text("タイプ")) {
                Picker("タイプ", selection: $viewModel.selectedType) {
                    ForEach(EntryType.allCases, id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.selectedType) {
                    viewModel.onTypeChanged()
                }
            }
            
            Section(header: Text("カテゴリ")) {
                Picker("カテゴリ", selection: $viewModel.selectedCategory) {
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
                    focusedField = nil
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
                .disabled(viewModel.amount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .listRowBackground(Color.clear)
            }
        }
        .onTapGesture {
            focusedField = nil
        }
    }
}
