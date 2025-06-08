import SwiftUI

enum FocusField: Hashable {
    case amount
    case memo
}

struct EntryFormView: View {
    @EnvironmentObject var listViewModel: EntryListViewModel

    @StateObject private var viewModel = EntryFormViewModel()

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
                EntryFormContentView(viewModel: viewModel)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("完了") {
                        viewModel.focusedField = nil
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
