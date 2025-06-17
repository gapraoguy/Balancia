import Foundation

protocol CategoryColorServiceProtocol {
    func getAllColors() -> [CategoryColor]
    func getAvailableColors() -> [CategoryColor]
    func isColorUsed(_ hex: String, excluding category: Category?) -> Bool
    func reserveColor(_ hex: String) throws
    func releaseColor(_ hex: String)
}
