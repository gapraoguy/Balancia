import SwiftUI

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
