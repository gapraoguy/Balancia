import SwiftUI

enum FocusField: Hashable {
    case amount
    case memo
}

struct EntryFormView: View {
    @EnvironmentObject var listViewModel: EntryListViewModel
    @EnvironmentObject var viewModel: EntryFormViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.focusedField = nil
                    }

                VStack {
                    EntryFormContentView(viewModel: viewModel)
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
