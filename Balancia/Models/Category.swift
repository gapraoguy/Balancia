import Foundation
import RealmSwift

class Category: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var type: EntryType
    @Persisted var iconName: String
    @Persisted var colorHex: String
}
