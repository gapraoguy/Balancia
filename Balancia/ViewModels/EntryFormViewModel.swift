import Foundation

class EntryFormViewModel: ObservableObject {
    @Published var amount: String = ""
    @Published var selectedType: EntryType = .expense
    @Published var selectedCategory: CategoryModel?
    @Published var date: Date = .init()
    @Published var memo: String = ""
    @Published var filteredCategories: [CategoryModel] = []
    @Published var saved: Bool = false
    @Published var focusedField: FocusField?

    @Published var existingEntry: EntryModel?
    private let entryRepository: EntryRepositoryProtocol
    private let categoryRepository: CategoryRepositoryProtocol

    init(
        entry: EntryModel? = nil,
        entryRepository: EntryRepositoryProtocol = EntryRepository(),
        categoryRepository: CategoryRepositoryProtocol = CategoryRepository()
    ) {
        self.entryRepository = entryRepository
        self.categoryRepository = categoryRepository
        existingEntry = entry

        if let entry = entry {
            amount = String(entry.amount)
            selectedType = entry.type
            selectedCategory = entry.category
            date = entry.date
            memo = entry.memo ?? ""
        }

        loadCategories()
    }

    func loadCategories() {
        let all = categoryRepository.get(by: selectedType).sorted { $0.name < $1.name }
        filteredCategories = all

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
        if existingEntry != nil {
            updateEntry()
        } else {
            createEntry()
        }
        saved = true
    }

    private func createEntry() {
        guard let amountInt = Int(amount),
              let category = selectedCategory else { return }

        let newEntry = EntryModel(
            amount: amountInt,
            category: category,
            memo: memo,
            tags: [],
            type: selectedType,
            date: date
        )

        entryRepository.create(newEntry)
    }

    private func updateEntry() {
        guard let amountInt = Int(amount),
              let category = selectedCategory,
              var entry = existingEntry else { return }

        entry.amount = amountInt
        entry.category = category
        entry.memo = memo
        entry.type = selectedType
        entry.date = date

        entryRepository.update(entry)
    }

    func setEntry(_ entry: EntryModel) {
        existingEntry = entry
        amount = String(entry.amount)
        selectedType = entry.type
        selectedCategory = entry.category
        date = entry.date
        memo = entry.memo ?? ""
        loadCategories()
    }

    func reset() {
        existingEntry = nil
        amount = ""
        selectedType = .expense
        selectedCategory = nil
        date = Date()
        memo = ""
        saved = false
        focusedField = nil
        loadCategories()
    }
}
