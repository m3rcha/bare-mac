import Foundation

struct Tweak: Identifiable {
    let id = UUID()
    let name: String
    let category: TweakCategory
    let detect: (() async -> Bool)?
    let setState: (Bool) async -> Bool

    init(name: String,
         category: TweakCategory,
         detect: (() async -> Bool)? = nil,
         setState: @escaping (Bool) async -> Bool) {
        self.name = name
        self.category = category
        self.detect = detect
        self.setState = setState
    }
}
