import Foundation
import RealmSwift

class Entry: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var amount: Int
    @Persisted var category: Category?
    @Persisted var memo: String?
    @Persisted var tags: List<String>
    @Persisted var type: EntryType
    @Persisted var date: Date
}
