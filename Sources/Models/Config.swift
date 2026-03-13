import Foundation

struct Config: Codable {
    var hiddenApps: [String] // Bundle identifiers
    var iconOrder: [String]
    
    static let `default` = Config(hiddenApps: [], iconOrder: [])
}
