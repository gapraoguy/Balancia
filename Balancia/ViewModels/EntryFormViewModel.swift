import Foundation

class EntryFormViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var selectedType: EntryType = .expense
    @Published var selectedCategory: CategoryModel?
    @Published var date: Date = Date()
    @Published var memo: String = ""
    @Published var filteredCategories: [CategoryModel] = []
    @Published var saved: Bool = false
    @Published var focusedField: FocusField? = nil

    private var existingEntry: EntryModel?
    private let entryRepository: EntryRepositoryProtocol
    private let categoryRepository: CategoryRepositoryProtocol

    init(
        entry: EntryModel? = nil,
        entryRepository: EntryRepositoryProtocol = EntryRepository(),
        categoryRepository: CategoryRepositoryProtocol = CategoryRepository()
    ) {
        self.entryRepository = entryRepository
        self.categoryRepository = categoryRepository
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
        let all = categoryRepository.get(by: selectedType).sorted { $0.name < $1.name }
        self.filteredCategories = all

        if let selected = selectedCategory {
            if let updated = filteredCategories.first(where: { $0.id == selected.id }) {
                selectedCategory = nil
                DispatchQueue.main.async {
                    self.selectedCategory = updated
                }
            } else {
                selectedCategory = filteredCategories.first
            }
        } else {
            selectedCategory = filteredCategories.first
        }
    }

    func onTypeChanged() {
        selectedCategory = nil
        loadCategories()
        selectedCategory = filteredCategories.first
    }

    func saveEntry() {
        guard let amountInt = Int(amount),
              let category = selectedCategory else { return }

        var entry = existingEntry ?? EntryModel(
            amount: amountInt,
            category: category,
            memo: memo,
            tags: [],
            type: selectedType,
            date: date
        )

        entry.amount = amountInt
        entry.category = category
        entry.memo = memo
        entry.type = selectedType
        entry.date = date

        entryRepository.save(entry)
        saved = true
    }
}
