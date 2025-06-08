import Foundation
import RealmSwift

class EntryFormViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var selectedType: EntryType = .expense
    @Published var selectedCategory: Category?
    @Published var date: Date = Date()
    @Published var memo: String = ""

    @Published var filteredCategories: [Category] = []
    
    @Published var saved: Bool = false

    private var realm: Realm
    private var existingEntry: Entry?

    init(entry: Entry? = nil) {
        self.realm = try! Realm()
        self.existingEntry = entry

        if let entry = entry {
            self.amount = String(entry.amount)
            self.selectedType = entry.type
            self.selectedCategory = entry.category
            self.date = entry.date
            self.memo = entry.memo ?? ""
        }

        loadCategories()
    }

    func loadCategories() {
        let categories = realm.objects(Category.self)
            .filter("type == %@", selectedType.rawValue)
            .sorted(byKeyPath: "name")

        self.filteredCategories = Array(categories)
    }

    func onTypeChanged() {
        selectedCategory = nil
        loadCategories()
    }

    func saveEntry() {
        guard let amountInt = Int(amount),
              let category = selectedCategory else {
            print("金額の入力が不正です: \(amount)")
            return
        }

        do {
            try realm.write {
                if let existing = existingEntry {
                    existing.amount = amountInt
                    existing.category = category
                    existing.date = date
                    existing.memo = memo
                    existing.type = selectedType
                } else {
                    let entry = Entry()
                    entry.amount = amountInt
                    entry.date = date
                    entry.memo = memo
                    entry.type = selectedType
                    entry.category = category
                    realm.add(entry)
                }
            }
            saved = true
        } catch {
            print("Entry保存失敗: \(error.localizedDescription)")
        }
    }
}
