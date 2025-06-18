import SwiftUI

struct MainTabView: View {
    @StateObject private var entryFormViewModel = EntryFormViewModel()
    @StateObject private var summaryViewModel = SummaryViewModel()
    @StateObject private var entryListViewModel = EntryListViewModel()
    @State private var selectedTab: Tab = .entryForm
    
    enum Tab {
        case entryForm, entryList, summary, settings
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            EntryFormView()
                .tabItem {
                    Label("記録", systemImage: "plus.circle")
                }
                .tag(Tab.entryForm)
            
            EntryListView(selectedTab: $selectedTab)
                .tabItem {
                    Label("履歴", systemImage: "list.bullet")
                }
                .tag(Tab.entryList)

            SummaryView()
                .tabItem {
                    Label("集計", systemImage: "chart.bar.fill")
                }
                .tag(Tab.summary)
            
            
            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .environmentObject(entryFormViewModel)
        .environmentObject(summaryViewModel)
        .environmentObject(entryListViewModel)
    }
}
