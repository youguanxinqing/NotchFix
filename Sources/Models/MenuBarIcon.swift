import Foundation

struct MenuBarIcon: Identifiable, Codable {
    let id: String
    let name: String
    let bundleIdentifier: String?
    var isHidden: Bool
    
    init(id: String = UUID().uuidString, name: String, bundleIdentifier: String? = nil, isHidden: Bool = false) {
        self.id = id
        self.name = name
        self.bundleIdentifier = bundleIdentifier
        self.isHidden = isHidden
    }
}
