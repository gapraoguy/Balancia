import SwiftUI
import RealmSwift

struct CategoryInputSheet: View {
    @ObservedObject var viewModel: CategoryManagementViewModel
    @FocusState private var focusedField: CategoryFocusField?

    var body: some View {
        ZStack {
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    focusedField = nil
                }

            VStack(spacing: 24) {
                TitleSection()
                TypePickerSection(selectedType: $viewModel.selectedType)
                NameInputSection(categoryName: $viewModel.categoryName, focusedField: $focusedField)
                ColorPickerSection(viewModel: viewModel) 
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
    
    private struct ColorPickerSection: View {
        @ObservedObject var viewModel: CategoryManagementViewModel

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("色を選択")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6), spacing: 12) {
                    ForEach(viewModel.allColors, id: \.hex) { color in
                        ZStack {
                            Circle()
                                .fill(Color.hex(color.hex))
                                .frame(width: 36, height: 36)

                            if viewModel.selectedColorHex == color.hex {
                                Circle()
                                    .stroke(Color.blue, lineWidth: 3)
                                    .frame(width: 40, height: 40)
                            }

                            if viewModel.isColorUsed(color.hex) {
                                Circle()
                                    .fill(Color.black.opacity(0.25))
                                    .frame(width: 36, height: 36)

                                Rectangle()
                                    .fill(Color.white.opacity(0.8))
                                    .frame(width: 2, height: 40)
                                    .rotationEffect(.degrees(45))
                            }
                        }
                        .onTapGesture {
                            if !viewModel.isColorUsed(color.hex) || viewModel.selectedColorHex == color.hex {
                                viewModel.selectedColorHex = color.hex
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private struct ButtonSection: View {
        @ObservedObject var viewModel: CategoryManagementViewModel

        var body: some View {
            if viewModel.availableColors.isEmpty {
                Text("カテゴリー数が上限に達しました")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
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
}
