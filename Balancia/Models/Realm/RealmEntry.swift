import Foundation
import RealmSwift

class RealmEntry: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var amount: Int
    @Persisted var category: RealmCategory?
    @Persisted var memo: String?
    @Persisted var tags: List<String>
    @Persisted var type: EntryType
    @Persisted var date: Date
}

extension RealmEntry {
    func toModel() -> EntryModel {
        EntryModel(
            id: id,
            amount: amount,
            category: category?.toModel(),
            memo: memo,
            tags: Array(tags),
            type: type,
            date: date
        )
    }

    convenience init(from model: EntryModel, in realm: Realm) {
        self.init()
        id = model.id
        amount = model.amount
        if let categoryModel = model.category {
            category = realm.object(ofType: RealmCategory.self, forPrimaryKey: categoryModel.id)
        }
        memo = model.memo
        tags.append(objectsIn: model.tags)
        type = model.type
        date = model.date
    }
}
