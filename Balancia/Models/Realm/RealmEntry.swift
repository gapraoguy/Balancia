import RealmSwift
import Foundation

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
            id: self.id,
            amount: self.amount,
            category: self.category?.toModel(),
            memo: self.memo,
            tags: Array(self.tags),
            type: self.type,
            date: self.date
        )
    }

    convenience init(from model: EntryModel, in realm: Realm) {
        self.init()
        self.id = model.id
        self.amount = model.amount
        self.category = model.category.flatMap { RealmCategory(from: $0, in: realm) }
        self.memo = model.memo
        self.tags.append(objectsIn: model.tags)
        self.type = model.type
        self.date = model.date
    }
}
