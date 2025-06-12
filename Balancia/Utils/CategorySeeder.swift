import Foundation
import RealmSwift

struct CategorySeeder {
    static func seedIfNeeded() {
        do {
            let realm = try Realm()
            
            if realm.objects(Category.self).count > 0 {
                return
            }
            
            let expenseCategories = [
                ("食費", "#FF3B30"), //systemRed
                ("交通", "#5AC8FA"), //systemTeal
                ("交際費", "#FF2D55"), //systemPink
                ("日用品", "#8E8E93"), //systemGray
                ("娯楽", "#AF52DE") // systemPurple
            ]
            let incomeCategories = [
                ("給与", "#34C759"), // systemGreen
                ("お小遣い", "#32D74B"), // systemMint
                ("売上", "#0A84FF") // systemBlue
            ]
            
            try realm.write {
                for (name, color) in expenseCategories {
                    let category = Category()
                    category.name = name
                    category.colorHex = color
                    category.type = .expense
                    realm.add(category)
                }
                for (name, color) in incomeCategories {
                    let category = Category()
                    category.name = name
                    category.colorHex = color
                    category.type = .income
                    realm.add(category)
                }
            }
            
        } catch {
            print("Category seeding failed: \(error.localizedDescription)")
        }
    }
}

