import Foundation

struct CategorySeeder {
    static func seedIfNeeded(
        categoryRepository: CategoryRepositoryProtocol = CategoryRepository(),
        colorRepository: CategoryColorRepositoryProtocol = CategoryColorRepository()
    ) {
        print(categoryRepository.getAll().count)
        print(colorRepository.getAll().count)
        if categoryRepository.getAll().count > 0 {
            return
        }

        let allColors = [
            "FF3B30", "FF9500", "FFD60A", "34C759", "32D74B", "5AC8FA",
            "64D2FF", "0A84FF", "5856D6", "AF52DE", "FF2D55", "8E8E93"
        ]

        let expenseCategories = ["食費", "交通", "交際費", "日用品", "娯楽"]
        let incomeCategories = ["給与", "お小遣い", "売上"]

        do {
            for hex in allColors {
                let color = CategoryColorModel(hex: hex, isUsed: false)
                colorRepository.save(color)
                print(color)
            }

            for (index, name) in expenseCategories.enumerated() {
                let colorHex = allColors[index]
                print(index)
                print(colorHex)
                try colorRepository.reserveColor(colorHex)
                
                if let color = colorRepository.get(byHex: colorHex) {
                    print(color)
                    let category = CategoryModel(name: name, type: .expense, color: color)
                    print(category)
                    categoryRepository.create(category)
                }
                
            }

            for (index, name) in incomeCategories.enumerated() {
                let colorHex = allColors[expenseCategories.count + index]
                print(index)
                print(colorHex)
                try colorRepository.reserveColor(colorHex)
                if let color = colorRepository.get(byHex: colorHex) {
                    print(color)
                    let category = CategoryModel(name: name, type: .income, color: color)
                    print(category)
                    categoryRepository.create(category)
                }
            }

        } catch {
            print("Category seeding failed: \(error.localizedDescription)")
        }
    }
}
