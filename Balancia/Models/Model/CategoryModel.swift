import RealmSwift
import Foundation

struct CategoryModel: Identifiable, Hashable {
    var id: ObjectId = ObjectId.generate()
    var name: String
    var type: EntryType
    var color: CategoryColorModel?
}
