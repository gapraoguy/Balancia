import SwiftUI

struct EntryFormView: View {
    @EnvironmentObject var listViewModel: EntryListViewModel
    @EnvironmentObject var viewModel: EntryFormViewModel

    var body: some View {
        NavigationView {
            VStack {
                EntryFormContentView(viewModel: viewModel)
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
