import Foundation
import RealmSwift

enum EntryType: String, PersistableEnum, CaseIterable {
    case expense
    case income

    var displayName: String {
        switch self {
        case .income: return "収入"
        case .expense: return "支出"
        }
    }
}
