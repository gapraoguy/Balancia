import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var entryFormViewModel: EntryFormViewModel
    @StateObject private var categoryVM = CategoryManagementViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("カテゴリ管理", destination: CategoryManagementView(viewModel: categoryVM))
            }
            .onChange(of: categoryVM.categoryUpdated) { updated in
                if updated {
                    print("reload categories")
                    entryFormViewModel.loadCategories()
                    categoryVM.categoryUpdated = false
                }
            }
        }
    }
}
