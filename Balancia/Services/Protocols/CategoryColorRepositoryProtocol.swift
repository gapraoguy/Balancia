import Foundation

protocol CategoryColorRepositoryProtocol {
    func getAll() -> [CategoryColorModel]
    func getAvailable() -> [CategoryColorModel]
    func get(byHex hex: String) -> CategoryColorModel? 
    func isColorUsed(_ hex: String, excluding category: CategoryModel?) -> Bool
    func reserveColor(_ hex: String) throws
    func releaseColor(_ hex: String)
    func save(_ color: CategoryColorModel)
}
