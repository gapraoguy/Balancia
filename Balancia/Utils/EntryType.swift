import Foundation
import RealmSwift

enum EntryType: String, PersistableEnum, CaseIterable {
    case expense
    case income
}
