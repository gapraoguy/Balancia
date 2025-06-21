import Foundation
import RealmSwift

struct CategoryModel: Identifiable, Hashable {
    var id: ObjectId = .generate()
    var name: String
    var type: EntryType
    var color: CategoryColorModel?
}
