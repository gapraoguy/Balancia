import Foundation
import RealmSwift

struct EntryModel: Identifiable, Hashable {
    var id: ObjectId = .generate()
    var amount: Int
    var category: CategoryModel?
    var memo: String?
    var tags: [String]
    var type: EntryType
    var date: Date
}
