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
            id: id,
            name: name,
            type: type,
            color: color?.toModel()
        )
    }

    convenience init(from model: CategoryModel, in realm: Realm) {
        self.init()
        id = model.id
        name = model.name
        type = model.type
        if let colorModel = model.color {
            color = realm.object(ofType: RealmCategoryColor.self, forPrimaryKey: colorModel.hex)
        }
    }
}
