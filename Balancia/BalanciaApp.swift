import SwiftUI
import RealmSwift

@main
struct BalanciaApp: App {
    init() {
        CategorySeeder.seedIfNeeded()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
