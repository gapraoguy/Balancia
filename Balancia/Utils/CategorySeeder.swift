import Foundation
import RealmSwift

struct CategorySeeder {
    static func seedIfNeeded() {
        do {
            let realm = try Realm()
            
            if realm.objects(Category.self).count > 0 {
                return
            }

            // default color palet
            let allColors = [
                "FF3B30",  // systemRed
                "FF9500",  // systemOrange
                "FFD60A",  // systemYellow
                "34C759",  // systemGreen
                "32D74B",  // systemMint
                "5AC8FA",  // systemTeal
                "64D2FF",  // systemCyan
                "0A84FF",  // systemBlue
                "5856D6",  // systemIndigo
                "AF52DE",  // systemPurple
                "FF2D55",  // systemPink
                "8E8E93"   // systemGray
            ]
            
            let expenseCategories = [
                "食費",
                "交通",
                "交際費",
                "日用品",
                "娯楽"
            ]
            let incomeCategories = [
                "給与",
                "お小遣い",
                "売上"
            ]
            
            try realm.write {
                // 1. すべての色を CategoryColor として登録
                for hex in allColors {
                    let color = CategoryColor()
                    color.hex = hex
                    color.isUsed = false
                    realm.add(color)
                }
                
                // 2. 各カテゴリを作成し、色を割り当てて isUsed = true に
                for (index, name) in expenseCategories.enumerated() {
                    guard let color = realm.object(ofType: CategoryColor.self, forPrimaryKey: allColors[index]) else { continue }
                    let category = Category()
                    category.name = name
                    category.type = .expense
                    category.color = color
                    color.isUsed = true
                    realm.add(category)
                }
                
                for (index, name) in incomeCategories.enumerated() {
                    let colorHex = allColors[expenseCategories.count + index]
                    guard let color = realm.object(ofType: CategoryColor.self, forPrimaryKey: colorHex) else { continue }
                    let category = Category()
                    category.name = name
                    category.type = .income
                    category.color = color
                    color.isUsed = true
                    realm.add(category)
                }
            }

        } catch {
            print("Category seeding failed: \(error.localizedDescription)")
        }
    }
}
