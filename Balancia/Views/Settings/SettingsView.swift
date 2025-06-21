import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var summaryViewModel: SummaryViewModel
    @EnvironmentObject var entryListViewModel: EntryListViewModel
    @EnvironmentObject var entryFormViewModel: EntryFormViewModel
    @StateObject private var categoryVM = CategoryManagementViewModel()

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("カテゴリ管理", destination: CategoryManagementView(viewModel: categoryVM))
            }
            .onChange(of: categoryVM.categoryUpdated) {
                if categoryVM.categoryUpdated {
                    entryFormViewModel.loadCategories()
                    entryListViewModel.loadEntries()
                    summaryViewModel.calculate(from: entryListViewModel.entries)
                    categoryVM.categoryUpdated = false
                }
            }
        }
    }
}
