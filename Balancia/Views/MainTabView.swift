import SwiftUI

struct MainTabView: View {
    
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
        }
        .environmentObject(entryListViewModel)
    }
}
