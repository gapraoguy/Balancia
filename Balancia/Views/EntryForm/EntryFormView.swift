import SwiftUI

enum FocusField: Hashable {
    case amount
    case memo
}

struct EntryFormView: View {
    @EnvironmentObject var listViewModel: EntryListViewModel
    @EnvironmentObject var viewModel: EntryFormViewModel
    @FocusState private var focusedField: FocusField?

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        focusedField = nil
                    }

                VStack(spacing: 24) {
                    TypePickerSection(viewModel: viewModel, selectedType: $viewModel.selectedType)
                    DateSection(viewModel: viewModel)
                    CategoryPickerSection(viewModel: viewModel)
                    AmountFieldSection(viewModel: viewModel, focusedField: $focusedField)
                    MemoFieldSection(viewModel: viewModel, focusedField: $focusedField)
                    
                    Divider()
                    ButtonSection(viewModel: viewModel)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                )
                .padding()
            }
            .onChange(of: viewModel.focusedField) {
                focusedField = viewModel.focusedField
            }
            .onChange(of: focusedField) {
                viewModel.focusedField = focusedField
            }
            .alert("保存しました", isPresented: $viewModel.saved) {
                Button("OK", role: .cancel) {
                    listViewModel.loadEntries()
                    viewModel.amount = ""
                    viewModel.memo = ""
                    viewModel.date = Date()
                    viewModel.selectedType = .expense
                    viewModel.selectedCategory = viewModel.filteredCategories.first!
                }
            }
        }
    }
    
    private struct DateSection: View {
        @ObservedObject var viewModel: EntryFormViewModel
        @State private var showDatePicker = false

        var body: some View {
            VStack {
                HStack {
                    Label("日付", systemImage: "calendar")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(formattedDate(viewModel.date))
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .imageScale(.small)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 1)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    showDatePicker = true
                }
            }
            .padding(.horizontal)
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker(
                        "日付を選択",
                        selection: $viewModel.date,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    Button("完了") {
                        showDatePicker = false
                    }
                    .padding()
                }
                .presentationDetents([.medium])
            }
        }

        private func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter.string(from: date)
        }
    }
    
    private struct TypePickerSection: View {
        @ObservedObject var viewModel: EntryFormViewModel
        @Binding var selectedType: EntryType

        var body: some View {
            Picker("タイプ", selection: $selectedType) {
                ForEach(EntryType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: viewModel.selectedType) {
                viewModel.onTypeChanged()
            }
            .padding(.horizontal)
        }
    }
    
    private struct CategoryPickerSection: View {
        @ObservedObject var viewModel: EntryFormViewModel
        
        var body: some View {
            Menu {
                ForEach(viewModel.filteredCategories, id: \.id) { category in
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        Text(category.name)
                    }
                }
            } label: {
                HStack {
                    Text("カテゴリ")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(viewModel.selectedCategory?.name ?? "未選択")
                        .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                        .imageScale(.small)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 1)
                )
            }
            .padding(.horizontal)
        }
    }
    
    private struct AmountFieldSection: View {
        @ObservedObject var viewModel: EntryFormViewModel
        @FocusState.Binding var focusedField: FocusField?
        
        var body: some View {
            TextField("¥0", text: $viewModel.amount)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .amount)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 1)
                )
                .padding(.horizontal)
        }
    }
    
    private struct MemoFieldSection: View {
        @ObservedObject var viewModel: EntryFormViewModel
        @FocusState.Binding var focusedField: FocusField?
        
        var body: some View {
            TextField("メモ", text: $viewModel.memo)
                .focused($focusedField, equals: .memo)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 1)
                )
                .padding(.horizontal)
        }
    }
    
    private struct ButtonSection: View {
        @ObservedObject var viewModel: EntryFormViewModel
        
        var body: some View {
            VStack(spacing: 12) {
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
                    .background(Color.accentColor)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(viewModel.amount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            
        }
    }
}
