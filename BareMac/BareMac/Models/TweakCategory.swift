import Foundation

enum TweakCategory: String, CaseIterable {
    case system = "System"
}

struct Tweak: Identifiable {
    let id = UUID()
    let name: String
    let command: String
    let revertCommand: String
    let category: TweakCategory
}
