import Foundation
import RealmSwift

class CategoryColor: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var hex: String
    @Persisted var isUsed: Bool = false
    let categories = LinkingObjects(fromType: Category.self, property: "color")
}
