import RealmSwift

class RealmCategory: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var type: EntryType
    @Persisted var color: RealmCategoryColor?
}

extension RealmCategory {
    func toModel() -> CategoryModel {
        CategoryModel(
            id: self.id,
            name: self.name,
            type: self.type,
            color: self.color?.toModel()
        )
    }

    convenience init(from model: CategoryModel, in realm: Realm) {
        self.init()
        self.id = model.id
        self.name = model.name
        self.type = model.type
        if let colorModel = model.color {
            self.color = realm.object(ofType: RealmCategoryColor.self, forPrimaryKey: colorModel.hex)
        }
    }
}
