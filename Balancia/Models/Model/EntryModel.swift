import RealmSwift
import Foundation

struct EntryModel: Identifiable, Hashable {
    var id: ObjectId = ObjectId.generate()
    var amount: Int
    var category: CategoryModel?
    var memo: String?
    var tags: [String]
    var type: EntryType
    var date: Date
}
