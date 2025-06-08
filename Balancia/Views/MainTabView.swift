import SwiftUI

struct MainTabView: View {
    @StateObject private var entryFormViewModel = EntryFormViewModel()
    @StateObject private var entryListViewModel = EntryListViewModel()
    
    var body: some View {
        
        TabView {
            EntryFormView()
                .tabItem {
                    Label("記録", systemImage: "plus.circle")
                }

            EntryListView()
                .tabItem {
                    Label("履歴", systemImage: "list.bullet")
                }

            SummaryView()
                .tabItem {
                    Label("集計", systemImage: "chart.bar.fill")
                }
            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
        }
        .environmentObject(entryFormViewModel)
        .environmentObject(entryListViewModel)
    }
}
