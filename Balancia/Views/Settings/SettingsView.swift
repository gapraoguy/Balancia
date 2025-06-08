import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("カテゴリ管理", destination: CategoryManagementView())
            }
            .navigationTitle("設定")
        }
    }
}
