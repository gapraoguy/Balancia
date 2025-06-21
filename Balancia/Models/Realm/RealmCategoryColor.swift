import RealmSwift

class RealmCategoryColor: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var hex: String
    @Persisted var isUsed: Bool = false
    let categories = LinkingObjects(fromType: RealmCategory.self, property: "color")
}

extension RealmCategoryColor {
    func toModel() -> CategoryColorModel {
        CategoryColorModel(hex: hex, isUsed: isUsed)
    }

    convenience init(from model: CategoryColorModel) {
        self.init()
        hex = model.hex
        isUsed = model.isUsed
    }
}
