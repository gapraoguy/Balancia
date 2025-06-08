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
                ("食費", "fork.knife", "#FFB6B6"),
                ("交通", "car", "#A0E7E5"),
                ("交際費", "person.2.fill", "#FFDAC1"),
                ("日用品", "cart.fill", "#E2F0CB"),
                ("娯楽", "gamecontroller.fill", "#B5EAD7")
            ]
            let incomeCategories = [
                ("給与", "briefcase.fill", "#C7CEEA"),
                ("お小遣い", "gift.fill", "#FFD6A5"),
                ("売上", "dollarsign.circle", "#FF9AA2")
            ]
            
            try realm.write {
                for (name, icon, color) in expenseCategories {
                    let category = Category()
                    category.name = name
                    category.iconName = icon
                    category.colorHex = color
                    category.type = .expense
                    realm.add(category)
                }
                for (name, icon, color) in incomeCategories {
                    let category = Category()
                    category.name = name
                    category.iconName = icon
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

